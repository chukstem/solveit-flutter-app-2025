<?php

namespace App\Http\Controllers;

use App\Models\Forum;
use App\Models\ForumMember;
use App\Models\ForumMessage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ForumController extends Controller
{
    /**
     * Get all forums (with optional filtering)
     */
    public function index(Request $request)
    {
        $userId = auth()->id();
        $perPage = $request->get('per_page', 20);
        $filter = $request->get('filter', 'all'); // all, my_forums, public

        $query = Forum::with(['creator', 'category', 'latestMessage.user', 'media'])
            ->where('is_active', true);

        if ($filter === 'my_forums') {
            $query->whereHas('members', function ($q) use ($userId) {
                $q->where('user_id', $userId);
            });
        } elseif ($filter === 'public') {
            $query->where('is_public', true);
        }

        $forums = $query->orderBy('created_at', 'desc')->paginate($perPage);

        // Add member count and unread count for each forum
        $forums->getCollection()->transform(function ($forum) use ($userId) {
            $forum->member_count = $forum->member_count;
            $forum->unread_count = $forum->getUnreadCount($userId);
            $forum->is_member = $forum->isMember($userId);
            return $forum;
        });

        return $this->success($forums);
    }

    /**
     * Search forums by name, description, or code
     * Only returns public forums or forums matching the provided code
     */
    public function search(Request $request)
    {
        $userId = auth()->id();
        $query = $request->get('query', '');
        $perPage = $request->get('per_page', 20);
        
        if (empty($query)) {
            // Return empty pagination response
            return $this->success([
                'data' => [],
                'current_page' => 1,
                'last_page' => 1,
                'per_page' => $perPage,
                'total' => 0,
            ]);
        }

        $searchQuery = Forum::with(['creator', 'category', 'latestMessage.user', 'media'])
            ->where('is_active', true)
            ->where(function ($q) use ($query) {
                // Search by name or description if forum is public
                $q->where(function ($subQ) use ($query) {
                    $subQ->where('is_public', true)
                        ->where(function ($nameDescQ) use ($query) {
                            $nameDescQ->where('name', 'like', "%{$query}%")
                                     ->orWhere('description', 'like', "%{$query}%");
                        });
                })
                // OR search by exact code match (regardless of is_public)
                ->orWhere('code', '=', $query);
            });

        $forums = $searchQuery->orderBy('created_at', 'desc')->paginate($perPage);

        // Add member count and unread count for each forum
        $forums->getCollection()->transform(function ($forum) use ($userId) {
            $forum->member_count = $forum->member_count;
            $forum->unread_count = $forum->getUnreadCount($userId);
            $forum->is_member = $forum->isMember($userId);
            return $forum;
        });

        return $this->success($forums);
    }

    /**
     * Get total unread count across all forums user is a member of
     */
    public function getTotalUnreadCount()
    {
        $userId = auth()->id();
        
        // Get all forums the user is a member of
        $forums = Forum::whereHas('members', function ($q) use ($userId) {
            $q->where('user_id', $userId);
        })->get();
        
        // Calculate total unread count
        $totalUnread = 0;
        foreach ($forums as $forum) {
            $totalUnread += $forum->getUnreadCount($userId);
        }
        
        return $this->success(['unread_count' => $totalUnread]);
    }

    /**
     * Get single forum details
     */
    public function show($id)
    {
        $userId = auth()->id();
        
        $forum = Forum::with(['creator', 'category', 'level', 'members.user', 'media'])
            ->find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        $forum->member_count = $forum->member_count;
        $forum->unread_count = $forum->getUnreadCount($userId);
        $forum->is_member = $forum->isMember($userId);
        $forum->can_moderate = $forum->canModerate($userId);
        
        // Add is_admin and role information to each member
        if ($forum->members) {
            $forum->members->transform(function ($member) {
                $member->is_admin = $member->role === 'admin';
                return $member;
            });
        }
        
        // Only include code for admins
        if (!$forum->isAdmin($userId)) {
            $forum->makeHidden(['code']);
        }

        return $this->success($forum);
    }

    /**
     * Create a new forum
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'image' => 'nullable|file|mimes:jpeg,jpg,png|max:5120', // 5MB max, only jpg/jpeg/png
            'category_id' => 'nullable|exists:news_categories,id',
            'is_public' => 'boolean',
            'max_members' => 'nullable|integer|min:2',
        ]);

        $validated['created_by'] = auth()->id();
        
        // Automatically set the forum's level to the creator's current level
        $user = auth()->user();
        $validated['level_id'] = $user->level_id;

        $forum = Forum::create($validated);

        // Handle cover image upload
        if ($request->hasFile('image')) {
            $forum->addMedia($request->file('image'))->toMediaCollection('cover');
        }

        // Automatically add creator as member with admin role
        ForumMember::create([
            'forum_id' => $forum->id,
            'user_id' => auth()->id(),
            'role' => 'admin',
        ]);

        return $this->success($forum->load('media'), 'Forum created successfully');
    }

    /**
     * Update forum
     */
    public function update(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Check if user is admin
        if (!$forum->canEdit(auth()->id())) {
            return $this->error('Only forum admins can update the forum', 403);
        }

        $validated = $request->validate([
            'name' => 'string|max:255',
            'description' => 'nullable|string',
            'image' => 'nullable|file|mimes:jpeg,jpg,png|max:5120', // 5MB max, only jpg/jpeg/png
            'category_id' => 'nullable|exists:news_categories,id',
            'is_public' => 'boolean',
            'max_members' => 'nullable|integer|min:2',
            'is_active' => 'boolean',
        ]);

        $forum->update($validated);

        // Handle cover image upload
        if ($request->hasFile('image')) {
            $forum->clearMediaCollection('cover');
            $forum->addMedia($request->file('image'))->toMediaCollection('cover');
        }

        return $this->success($forum->load('media'), 'Forum updated successfully');
    }

    /**
     * Delete forum
     */
    public function destroy($id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Only admins can delete
        if (!$forum->canDelete(auth()->id())) {
            return $this->error('Only forum admins can delete the forum', 403);
        }

        $forum->delete();

        return $this->success(null, 'Forum deleted successfully');
    }

    /**
     * Join a forum
     */
    public function join($id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        if (!$forum->is_public) {
            return $this->error('This forum is private', 403);
        }

        if ($forum->isMember(auth()->id())) {
            return $this->error('You are already a member of this forum', 400);
        }

        // Check member limit
        if ($forum->max_members && $forum->member_count >= $forum->max_members) {
            return $this->error('Forum has reached maximum member limit', 400);
        }

        ForumMember::create([
            'forum_id' => $forum->id,
            'user_id' => auth()->id(),
            'role' => 'member',
        ]);

        return $this->success(null, 'Successfully joined the forum');
    }

    /**
     * Leave a forum
     */
    public function leave($id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', auth()->id())
            ->first();

        if (!$member) {
            return $this->error('You are not a member of this forum', 400);
        }

        // Prevent creator from leaving if they're the only admin
        if ($member->role === 'admin') {
            $adminCount = ForumMember::where('forum_id', $id)
                ->where('role', 'admin')
                ->count();

            if ($adminCount === 1) {
                return $this->error('You must assign another admin before leaving', 400);
            }
        }

        $member->delete();

        return $this->success(null, 'Successfully left the forum');
    }

    /**
     * Toggle mute notifications for a forum
     */
    public function toggleMute($id)
    {
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', auth()->id())
            ->first();

        if (!$member) {
            return $this->error('You are not a member of this forum', 400);
        }

        $member->update(['muted' => !$member->muted]);

        return $this->success([
            'muted' => $member->muted
        ], $member->muted ? 'Forum muted' : 'Forum unmuted');
    }

    /**
     * Get forum members with pagination and search
     */
    public function getMembers(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        $perPage = $request->get('per_page', 20);
        $search = $request->get('search', '');

        $query = ForumMember::with(['user'])
            ->where('forum_id', $id);

        // Search by user name
        if (!empty($search)) {
            $query->whereHas('user', function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%"); 
            });
        }

        // Order by role (admin, moderator, member) then by name
        $members = $query->orderByRaw("FIELD(role, 'admin', 'moderator', 'member')")
            ->orderBy('created_at', 'asc')
            ->paginate($perPage);

        // Add admin information to each member (based on role)
        $members->getCollection()->transform(function ($member) {
            $member->is_admin = $member->role === 'admin';
            return $member;
        });

        return $this->success($members);
    }

    /**
     * Get forum media files with pagination and type filtering
     */
    public function getMedia(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        if (!$forum->isMember(auth()->id())) {
            return $this->error('You must be a member to view media', 403);
        }

        $perPage = $request->get('per_page', 20);
        $type = $request->get('type', 'all'); // all, image, audio, document, video

        $query = ForumMessage::with(['user', 'media'])
            ->where('forum_id', $id);

        // Filter by media type - query the media table, not forum_messages
        if ($type !== 'all') {
            $query->whereHas('media', function($mediaQuery) use ($type) {
                // Map common type names to MIME type patterns
                switch ($type) {
                    case 'image':
                        $mediaQuery->where('mime_type', 'like', 'image/%');
                        break;
                    case 'video':
                        $mediaQuery->where('mime_type', 'like', 'video/%');
                        break;
                    case 'audio':
                        $mediaQuery->where('mime_type', 'like', 'audio/%');
                        break;
                    case 'document':
                        $mediaQuery->whereIn('mime_type', [
                            'application/pdf',
                            'application/msword',
                            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                            'application/vnd.ms-excel',
                            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                            'application/vnd.ms-powerpoint',
                            'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                            'text/plain',
                        ]);
                        break;
                }
            });
        } else {
            // Only show messages that have media
            $query->whereHas('media');
        }

        $messages = $query->orderBy('created_at', 'desc')
            ->paginate($perPage);

        return $this->success($messages);
    }

    /**
     * Get forum messages
     */
    public function getMessages($id, Request $request)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        if (!$forum->isMember(auth()->id())) {
            return $this->error('You must be a member to view messages', 403);
        }

        $perPage = $request->get('per_page', 50);

        $messages = ForumMessage::with(['user', 'replyTo.user', 'media', 'replyTo.media'])
            ->where('forum_id', $id)
            ->orderBy('created_at', 'asc')
            ->paginate($perPage);

        // Mark forum as read
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', auth()->id())
            ->first();
        
        if ($member) {
            $member->markAsRead();
        }

        return $this->success($messages);
    }

    /**
     * Send a message to forum
     */
    public function sendMessage(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        if (!$forum->isMember(auth()->id())) {
            return $this->error('You must be a member to send messages', 403);
        }

        $validated = $request->validate([
            'message' => 'nullable|string',
            'media' => 'nullable|array',
            'media.*' => 'file|mimes:jpeg,png,jpg,gif,mp4,mp3,pdf,doc,docx,wav,m4a,avi,mov|max:20480',
            'reply_to_id' => 'nullable|exists:forum_messages,id',
        ]);

        if (empty($validated['message']) && !$request->hasFile('media')) {
            return $this->error('Message or media is required', 400);
        }

        $message = ForumMessage::create([
            'forum_id' => $id,
            'user_id' => auth()->id(),
            'message' => $validated['message'] ?? null,
            'reply_to_id' => $validated['reply_to_id'] ?? null,
        ]);

        // Handle media uploads
        if ($request->hasFile('media')) {
            foreach ($request->file('media') as $file) {
                $message->addMedia($file)->toMediaCollection('media');
            }
        }

        $message->load(['user', 'replyTo.user', 'media']);

        return $this->success($message, 'Message sent successfully');
    }

    /**
     * Update a message
     */
    public function updateMessage(Request $request, $messageId)
    {
        $message = ForumMessage::find($messageId);

        if (!$message) {
            return $this->notFound('Message not found');
        }

        if ($message->user_id !== auth()->id()) {
            return $this->error('You can only edit your own messages', 403);
        }

        $validated = $request->validate([
            'message' => 'required|string',
        ]);

        $message->update([
            'message' => $validated['message'],
            'is_edited' => true,
            'edited_at' => now(),
        ]);

        $message->load(['user', 'replyTo.user']);

        return $this->success($message, 'Message updated successfully');
    }

    /**
     * Delete a message
     */
    public function deleteMessage($messageId)
    {
        $message = ForumMessage::find($messageId);

        if (!$message) {
            return $this->notFound('Message not found');
        }

        $forum = $message->forum;

        // User can delete their own messages or moderators can delete any message
        if ($message->user_id !== auth()->id() && !$forum->canModerate(auth()->id())) {
            return $this->error('You do not have permission to delete this message', 403);
        }

        $message->delete();

        return $this->success(null, 'Message deleted successfully');
    }

    /**
     * Remove a member from the forum (admin only)
     */
    public function removeMember(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $userId = $validated['user_id'];

        // Don't allow removing yourself
        if ($userId === auth()->id()) {
            return $this->error('You cannot remove yourself from the forum', 400);
        }

        // Check if user is a member
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$member) {
            return $this->error('User is not a member of this forum', 404);
        }

        // Check if user has permission to remove this member based on their role
        if (!$forum->canRemoveMember(auth()->id(), $member->role)) {
            if ($member->role === 'admin') {
                return $this->error('Only admins can remove other admins', 403);
            } elseif ($member->role === 'moderator') {
                return $this->error('Only admins can remove moderators', 403);
            }
            return $this->error('You do not have permission to remove this member', 403);
        }

        // Don't allow removing the forum creator
        if ($forum->created_by === $userId) {
            return $this->error('Cannot remove the forum creator', 400);
        }

        // Remove from forum_members
        $member->delete();

        return $this->success(null, 'Member removed successfully');
    }

    /**
     * Make a member a moderator (admin only)
     */
    public function makeModerator(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Check if user can manage moderators
        if (!$forum->canManageModerators(auth()->id())) {
            return $this->error('Only forum admins can assign moderators', 403);
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $userId = $validated['user_id'];

        // Check if user is a member
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$member) {
            return $this->error('User must be a member of the forum first', 404);
        }

        // Check if already a moderator or admin
        if ($member->role === 'moderator') {
            return $this->error('User is already a moderator', 400);
        }

        if ($member->role === 'admin') {
            return $this->error('User is already an admin', 400);
        }

        // Update member role to moderator
        $member->update(['role' => 'moderator']);

        return $this->success(null, 'User is now a forum moderator');
    }

    /**
     * Remove moderator privileges (admin only)
     */
    public function removeModerator(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Check if user can manage moderators
        if (!$forum->canManageModerators(auth()->id())) {
            return $this->error('Only forum admins can remove moderator privileges', 403);
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $userId = $validated['user_id'];

        // Check if user is a member
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$member) {
            return $this->error('User is not a member of this forum', 404);
        }

        // Check if user is currently a moderator
        if ($member->role !== 'moderator') {
            return $this->error('User is not a moderator of this forum', 400);
        }

        // Update member role to member
        $member->update(['role' => 'member']);

        return $this->success(null, 'Moderator privileges removed successfully');
    }

    /**
     * Make a member an admin (admin only)
     */
    public function makeAdmin(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Check if user can manage admins
        if (!$forum->canManageAdmins(auth()->id())) {
            return $this->error('Only forum admins can assign other admins', 403);
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $userId = $validated['user_id'];

        // Check if user is a member
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$member) {
            return $this->error('User must be a member of the forum first', 404);
        }

        // Check if already an admin
        if ($member->role === 'admin') {
            return $this->error('User is already an admin', 400);
        }

        // Update member role to admin
        $member->update(['role' => 'admin']);

        return $this->success(null, 'User is now a forum admin');
    }

    /**
     * Remove admin privileges from a user (admin only)
     */
    public function removeAdmin(Request $request, $id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        // Check if user can assign admins
        if (!$forum->canAssignAdmins(auth()->id())) {
            return $this->error('Only forum admins can remove admin privileges', 403);
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $userId = $validated['user_id'];

        // Don't allow removing yourself as admin
        if ($userId === auth()->id()) {
            return $this->error('You cannot remove your own admin privileges', 400);
        }

        // Check if user is a member
        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$member) {
            return $this->error('User is not a member of this forum', 404);
        }

        // Check if user is currently an admin
        if ($member->role !== 'admin') {
            return $this->error('User is not an admin of this forum', 400);
        }

        // Don't allow removing the forum creator's admin privileges
        if ($forum->created_by === $userId) {
            return $this->error('Cannot remove admin privileges from the forum creator', 400);
        }

        // Update member role to member
        $member->update(['role' => 'member']);

        return $this->success(null, 'Admin privileges removed successfully');
    }

    /**
     * Mark forum messages as read
     */
    public function markAsRead($id)
    {
        $forum = Forum::find($id);

        if (!$forum) {
            return $this->notFound('Forum not found');
        }

        if (!$forum->isMember(auth()->id())) {
            return $this->error('You are not a member of this forum', 403);
        }

        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', auth()->id())
            ->first();
        
        if ($member) {
            $member->markAsRead();
        }

        return $this->success(null, 'Messages marked as read');
    }
}


