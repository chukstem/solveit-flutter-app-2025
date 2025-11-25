<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
    /**
     * Get all comments.
     */
    public function index(Request $request)
    {
        $query = Comment::with(['user', 'post']);

        if ($request->has('post_id')) {
            $query->where('post_id', $request->post_id);
        }

        $comments = $query->latest()->paginate(20);

        return $this->success($comments);
    }

    /**
     * Update comment.
     */
    public function update(Request $request, $id)
    {
        $comment = Comment::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'content' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $comment->content = $request->content;
        $comment->save();

        return $this->success($comment, 'Comment updated successfully');
    }

    /**
     * Delete comment.
     */
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);
        $comment->delete();

        return $this->success(null, 'Comment deleted successfully');
    }
}


