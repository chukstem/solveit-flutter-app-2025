<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Forum;
use App\Models\ForumMember;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ForumController extends Controller
{
    /**
     * Get all forums.
     */
    public function index(Request $request)
    {
        $query = Forum::with(['creator', 'category', 'level']);

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        $forums = $query->withCount('members')->latest()->paginate(20);

        return $this->success($forums);
    }

    /**
     * Get forum details with members.
     */
    public function show($id)
    {
        $forum = Forum::with(['creator', 'category', 'level', 'members.user'])
            ->withCount('members')
            ->findOrFail($id);

        return $this->success($forum);
    }

    /**
     * Update forum.
     */
    public function update(Request $request, $id)
    {
        $forum = Forum::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'is_active' => 'sometimes|boolean',
            'is_public' => 'sometimes|boolean',
            'max_members' => 'sometimes|integer|min:2',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $forum->update($request->all());

        return $this->success($forum, 'Forum updated successfully');
    }

    /**
     * Delete forum.
     */
    public function destroy($id)
    {
        $forum = Forum::findOrFail($id);
        $forum->delete();

        return $this->success(null, 'Forum deleted successfully');
    }

    /**
     * Remove member from forum.
     */
    public function removeMember(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $request->user_id)
            ->first();

        if (!$member) {
            return $this->notFound('Member not found in this forum');
        }

        $member->delete();

        return $this->success(null, 'Member removed successfully');
    }

    /**
     * Make user a forum admin.
     */
    public function makeAdmin(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $request->user_id)
            ->first();

        if (!$member) {
            return $this->notFound('Member not found in this forum');
        }

        $member->role = 'admin';
        $member->save();

        return $this->success($member, 'User promoted to admin successfully');
    }

    /**
     * Make user a forum moderator.
     */
    public function makeModerator(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $member = ForumMember::where('forum_id', $id)
            ->where('user_id', $request->user_id)
            ->first();

        if (!$member) {
            return $this->notFound('Member not found in this forum');
        }

        $member->role = 'moderator';
        $member->save();

        return $this->success($member, 'User promoted to moderator successfully');
    }
}


