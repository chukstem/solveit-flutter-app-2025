<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\ProductComment;
use App\Models\ProductReaction;
use App\Models\ProductTag;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class MarketController extends Controller
{
    /**
     * Get conversations for the authenticated user.
     */
    public function getConversations(Request $request)
    {
        $user = auth()->user();

        $conversations = Conversation::with(['participants', 'latestMessage.sender'])
            ->whereHas('participants', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            })
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
        $conversation = $this->findOrCreateConversation($sender->id, $receiver->id);

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
        
        return $this->success($message, 'Message sent successfully');
    }

    /**
     * Create a group conversation.
     */
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
     * Mark messages as read.
     */
    public function markAsRead(Request $request, $conversationId)
    {
        $user = auth()->user();

        // Check if user is participant of this conversation
        $conversation = Conversation::whereHas('participants', function ($query) use ($user) {
            $query->where('user_id', $user->id);
        })->find($conversationId);

        if (!$conversation) {
            return $this->notFound('Conversation not found');
        }

        // Mark messages as read
        Message::where('conversation_id', $conversationId)
            ->where('receiver_id', $user->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return $this->success(null, 'Messages marked as read');
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
     * Find or create a conversation between two users.
     */
    private function findOrCreateConversation($senderId, $receiverId)
    {
        // Try to find existing conversation
        $conversation = Conversation::where('type', 'private')
            ->whereHas('participants', function ($query) use ($senderId) {
                $query->where('user_id', $senderId);
            })
            ->whereHas('participants', function ($query) use ($receiverId) {
                $query->where('user_id', $receiverId);
            })
            ->first();

        if ($conversation) {
            return $conversation;
        }

        // Create new conversation
        $conversation = Conversation::create([
            'type' => 'private',
            'created_by' => $senderId,
        ]);

        // Add participants
        $conversation->participants()->attach([$senderId, $receiverId]);

        return $conversation;
    }
}
















