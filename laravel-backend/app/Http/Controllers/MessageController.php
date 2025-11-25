<?php

namespace App\Http\Controllers;

use App\Models\Message;
use App\Models\Conversation;
use App\Models\User;
use App\Events\MessageSent;
use App\Events\UserTyping;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class MessageController extends Controller
{
    /**
     * Get conversations for the authenticated user.
     */
    public function getConversations(Request $request)
    {
        $user = auth()->user();
        
        // Get filter parameter (all, marketplace, services)
        $origin = $request->query('origin', 'all');
        
        // Get page parameter
        $page = $request->query('page', 1);

        $query = Conversation::with([
                // Don't use select() on belongsToMany - it breaks pivot loading
                // Just load all participant columns and let User model append avatar_url and is_fully_verified
                'participants.verification',
                'latestMessage.sender'
            ])
            ->whereHas('participants', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            });

        // Apply origin filter if not 'all'
        if ($origin !== 'all' && in_array($origin, ['marketplace', 'services', 'other'])) {
            $query->where('origin', $origin);
        }

        $conversations = $query
            ->orderBy('updated_at', 'desc')
            ->paginate(20);

        return $this->success($conversations);
    }

    /**
     * Get messages for a conversation.
     */
    public function getMessages(Request $request, $conversationId)
    {
        $user = auth()->user();

        // Check if user is participant of this conversation
        $conversation = Conversation::whereHas('participants', function ($query) use ($user) {
            $query->where('user_id', $user->id);
        })->find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        $messages = Message::with(['sender', 'receiver', 'replyTo.sender'])
            ->where('conversation_id', $conversationId)
            ->orderBy('created_at', 'asc')
            ->paginate(50);

        // Mark messages as read
        Message::where('conversation_id', $conversationId)
            ->where('receiver_id', $user->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return $this->success($messages);
    }

    /**
     * Send a message.
     */
    public function sendMessage(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'receiver_id' => 'required|exists:users,id',
            'body' => 'nullable|string',
            'type' => 'nullable|string|in:text,image,video,audio,file',
            'origin' => 'nullable|string|in:marketplace,services,other',
            'reply_to' => 'nullable|exists:messages,id',
            'attachments' => 'nullable|array',
            'attachments.*' => 'file|mimes:jpeg,png,jpg,gif,mp4,mp3,pdf,doc,docx,wav,m4a,avi,mov,webm,ogg,aac|max:20480',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Require either body or attachments
        if (empty($request->body) && !$request->hasFile('attachments')) {
            return $this->error('Message body or attachments is required', 400);
        }

        $sender = auth()->user();
        $receiver = User::find($request->receiver_id);

        if (!$receiver) {
            return $this->notFound('Receiver not found');
        }

        // Find or create conversation
        $origin = $request->origin ?? 'other';
        $conversation = $this->findOrCreateConversation($sender->id, $receiver->id, $origin);

        // Create message
        $message = Message::create([
            'sender_id' => $sender->id,
            'receiver_id' => $receiver->id,
            'conversation_id' => $conversation->id,
            'body' => $request->body ?? null,
            'type' => $request->type ?? 'text',
            'reply_to' => $request->reply_to,
        ]);

        // Handle file uploads
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                $message->addMedia($file)->toMediaCollection('attachments');
            }
        }

        // Update conversation timestamp
        $conversation->touch();

        // Load relationships (media is loaded via accessor, not relationship)
        $message->load(['sender', 'receiver', 'replyTo']);
        
        // Broadcast message sent event for real-time delivery
        broadcast(new MessageSent($message, $conversation->id))->toOthers();
        
        return $this->success($message, 'Message sent successfully');
    }

    /**
     * Update a message (text only).
     */
    public function updateMessage(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'body' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $message = Message::find($id);

        if (!$message) {
            return $this->notFound('Message not found');
        }

        // Check if user is the sender
        if ($message->sender_id !== auth()->id()) {
            return $this->forbidden('You can only edit your own messages');
        }

        // Don't allow editing media messages
        if ($message->getMedia('attachments')->isNotEmpty()) {
            return $this->error('Messages with media cannot be edited', 400);
        }

        // Update the message
        $message->update([
            'body' => $request->body,
        ]);

        // Load relationships
        $message->load(['sender', 'receiver', 'replyTo']);

        return $this->success($message, 'Message updated successfully');
    }

    /**
     * Create a group conversation.
     */
    /**
     * Find or create a private conversation
     */
    public function findOrCreatePrivateConversation(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'receiver_id' => 'required|exists:users,id',
            'origin' => 'nullable|string|in:marketplace,services,other',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $sender = auth()->user();
        $receiverId = $request->receiver_id;
        $origin = $request->origin ?? 'other';

        Log::info('findOrCreatePrivateConversation API called', [
            'sender_id' => $sender->id,
            'sender_name' => $sender->name,
            'receiver_id' => $receiverId,
            'origin' => $origin,
        ]);

        // Find or create conversation
        $conversation = $this->findOrCreateConversation($sender->id, $receiverId, $origin);

        // Load the conversation with relationships for the response
        $conversation->load(['participants', 'latestMessage']);

        Log::info('Returning conversation', [
            'conversation_id' => $conversation->id,
            'participant_count' => $conversation->participants->count(),
        ]);

        return $this->success($conversation, 'Conversation found or created successfully');
    }

    public function createGroupConversation(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'participants' => 'required|array|min:1',
            'participants.*' => 'exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();

        // Create conversation
        $conversation = Conversation::create([
            'name' => $request->name,
            'type' => 'group',
            'created_by' => $user->id,
        ]);

        // Add participants
        $participants = array_merge([$user->id], $request->participants);
        $conversation->participants()->attach($participants);

        return $this->success($conversation->load(['participants', 'creator']), 'Group conversation created successfully');
    }

    /**
     * Add participants to a group conversation.
     */
    public function addParticipants(Request $request, $conversationId)
    {
        $validator = Validator::make($request->all(), [
            'participants' => 'required|array|min:1',
            'participants.*' => 'exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $conversation = Conversation::find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        // Check if user is participant
        if (!$conversation->participants()->where('user_id', auth()->id())->exists()) {
            return $this->forbidden('You are not a participant of this conversation');
        }

        // Add participants
        $conversation->participants()->syncWithoutDetaching($request->participants);

        return $this->success($conversation->load('participants'), 'Participants added successfully');
    }

    /**
     * Remove participants from a group conversation.
     */
    public function removeParticipants(Request $request, $conversationId)
    {
        $validator = Validator::make($request->all(), [
            'participants' => 'required|array|min:1',
            'participants.*' => 'exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $conversation = Conversation::find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        // Check if user is participant
        if (!$conversation->participants()->where('user_id', auth()->id())->exists()) {
            return $this->forbidden('You are not a participant of this conversation');
        }

        // Remove participants
        $conversation->participants()->detach($request->participants);

        return $this->success($conversation->load('participants'), 'Participants removed successfully');
    }

    /**
     * Delete a message.
     */
    public function deleteMessage($messageId)
    {
        $message = Message::find($messageId);

        if (!$message) {
            return $this->notFound('Message not found');
        }

        // Check if user can delete this message
        if ($message->sender_id !== auth()->id()) {
            return $this->forbidden('You can only delete your own messages');
        }

        $message->delete();

        return $this->success(null, 'Message deleted successfully');
    }

    /**
     * Get unread message count.
     */
    public function getUnreadCount()
    {
        $user = auth()->user();

        $unreadCount = Message::where('receiver_id', $user->id)
            ->where('is_read', false)
            ->count();

        return $this->success(['unread_count' => $unreadCount]);
    }

    /**
     * Search messages.
     */
    public function searchMessages(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'query' => 'required|string|min:2',
            'conversation_id' => 'nullable|exists:conversations,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();
        $query = Message::with(['sender', 'receiver', 'conversation'])
            ->where('body', 'like', "%{$request->query}%");

        // Filter by conversation if provided
        if ($request->has('conversation_id')) {
            $conversation = Conversation::whereHas('participants', function ($q) use ($user) {
                $q->where('user_id', $user->id);
            })->find($request->conversation_id);

            if (!$conversation) {
                return $this->notFound('Conversation not found');
            }

            $query->where('conversation_id', $request->conversation_id);
        } else {
            // Only search in conversations where user is participant
            $query->whereHas('conversation.participants', function ($q) use ($user) {
                $q->where('user_id', $user->id);
            });
        }

        $messages = $query->orderBy('created_at', 'desc')->paginate(20);

        return $this->success($messages);
    }

    /**
     * Broadcast typing indicator
     */
    public function typingIndicator(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'conversation_id' => 'required|integer|exists:conversations,id',
            'is_typing' => 'required|boolean',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();
        $conversationId = $request->conversation_id;

        // Check if user is participant in conversation
        $conversation = Conversation::whereHas('participants', function ($query) use ($user) {
            $query->where('user_id', $user->id);
        })->find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        // Broadcast typing event
        broadcast(new UserTyping($user->id, $user->name, $conversationId, $request->is_typing))->toOthers();

        return $this->success(null, 'Typing indicator sent');
    }

    /**
     * Find or create a conversation between two users.
     */
    private function findOrCreateConversation($senderId, $receiverId, $origin = 'other')
    {
        Log::info('findOrCreateConversation called', [
            'sender_id' => $senderId,
            'receiver_id' => $receiverId,
            'origin' => $origin,
        ]);

        // Debug: Check all existing participants for these users
        $senderConversations = DB::table('conversation_participants')
            ->where('user_id', $senderId)
            ->pluck('conversation_id')
            ->toArray();
        
        $receiverConversations = DB::table('conversation_participants')
            ->where('user_id', $receiverId)
            ->pluck('conversation_id')
            ->toArray();

        Log::info('Existing conversation_participants data', [
            'sender_conversations' => $senderConversations,
            'receiver_conversations' => $receiverConversations,
            'common_conversations' => array_intersect($senderConversations, $receiverConversations),
        ]);

        // Try to find existing conversation with same origin
        $conversation = Conversation::where('type', 'private')
            ->where('origin', $origin)
            ->whereHas('participants', function ($query) use ($senderId) {
                $query->where('user_id', $senderId);
            })
            ->whereHas('participants', function ($query) use ($receiverId) {
                $query->where('user_id', $receiverId);
            })
            ->first();

        if ($conversation) {
            Log::info('Found existing conversation', [
                'conversation_id' => $conversation->id,
                'participants' => $conversation->participants->pluck('id')->toArray(),
            ]);
            return $conversation;
        }

        Log::info('No existing conversation found, creating new one');

        // Create new conversation
        $conversation = Conversation::create([
            'type' => 'private',
            'origin' => $origin,
            'created_by' => $senderId,
        ]);

        // Add participants
        $conversation->participants()->attach([$senderId, $receiverId]);

        Log::info('Created new conversation', [
            'conversation_id' => $conversation->id,
            'participants' => [$senderId, $receiverId],
        ]);

        return $conversation;
    }

    /**
     * Mark messages as read for a conversation
     */
    public function markAsRead(Request $request, $conversationId)
    {
        $user = auth()->user();

        // Check if user is participant
        $conversation = Conversation::whereHas('participants', function ($query) use ($user) {
            $query->where('user_id', $user->id);
        })->find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        // Mark all unread messages where current user is receiver as read
        $updatedCount = Message::where('conversation_id', $conversationId)
            ->where('receiver_id', $user->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return $this->success([
            'message' => 'Messages marked as read',
            'count' => $updatedCount,
        ]);
    }

    /**
     * Mark specific message as delivered
     */
    public function markAsDelivered(Request $request, $messageId)
    {
        $user = auth()->user();

        $message = Message::find($messageId);

        if (!$message) {
            return $this->notFound('Message not found');
        }

        // Only the receiver can mark as delivered
        if ($message->receiver_id !== $user->id) {
            return $this->forbidden('You are not authorized to update this message');
        }

        $message->is_delivered = true;
        $message->save();

        return $this->success([
            'message' => 'Message marked as delivered',
            'data' => $message,
        ]);
    }

    /**
     * Mark multiple messages as delivered
     */
    public function markMessagesAsDelivered(Request $request)
    {
        $request->validate([
            'message_ids' => 'required|array',
            'message_ids.*' => 'required|integer|exists:messages,id',
        ]);

        $user = auth()->user();
        $messageIds = $request->message_ids;

        // Mark messages as delivered where current user is receiver
        $updatedCount = Message::whereIn('id', $messageIds)
            ->where('receiver_id', $user->id)
            ->where('is_delivered', false)
            ->update(['is_delivered' => true]);

        return $this->success([
            'message' => 'Messages marked as delivered',
            'count' => $updatedCount,
        ]);
    }
}
















