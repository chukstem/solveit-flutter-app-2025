<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PostController extends Controller
{
    /**
     * Create a new post.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'news_category_id' => 'required|exists:post_categories,id',
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string|max:500',
            'body' => 'required|string',
            'tags' => 'nullable|string',
            'faculties' => 'nullable|string',
            'departments' => 'nullable|string',
            'levels' => 'nullable|string',
            'interests' => 'nullable|string',
            'featured' => 'boolean',
            'enable_comments' => 'boolean',
            'enable_reactions' => 'boolean',
            'is_published' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();

        $post = Post::create([
            'user_id' => $user->id,
            'school_id' => $user->school_id,
            'news_category_id' => $request->news_category_id,
            'title' => $request->title,
            'excerpt' => $request->excerpt,
            'body' => $request->body,
            'tags' => $request->tags,
            'faculties' => $request->faculties,
            'departments' => $request->departments,
            'levels' => $request->levels,
            'interests' => $request->interests,
            'featured' => $request->boolean('featured', false),
            'enable_comments' => $request->boolean('enable_comments', true),
            'enable_reactions' => $request->boolean('enable_reactions', true),
            'is_published' => $request->boolean('is_published', true),
            'code' => \Str::random(10),
            'published_at' => $request->boolean('is_published', true) ? now() : null,
        ]);

        return $this->success($post->load(['user', 'school', 'category']), 'Post created successfully');
    }

    /**
     * Update a post.
     */
    public function update(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        $validator = Validator::make($request->all(), [
            'news_category_id' => 'sometimes|exists:post_categories,id',
            'title' => 'sometimes|string|max:255',
            'excerpt' => 'nullable|string|max:500',
            'body' => 'sometimes|string',
            'tags' => 'nullable|string',
            'faculties' => 'nullable|string',
            'departments' => 'nullable|string',
            'levels' => 'nullable|string',
            'interests' => 'nullable|string',
            'featured' => 'boolean',
            'enable_comments' => 'boolean',
            'enable_reactions' => 'boolean',
            'is_published' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $post->update($request->only([
            'news_category_id', 'title', 'excerpt', 'body', 'tags',
            'faculties', 'departments', 'levels', 'interests',
            'featured', 'enable_comments', 'enable_reactions', 'is_published'
        ]));

        if ($request->has('is_published') && $request->boolean('is_published') && !$post->published_at) {
            $post->update(['published_at' => now()]);
        }

        return $this->success($post->load(['user', 'school', 'category']), 'Post updated successfully');
    }

    /**
     * Delete a post.
     */
    public function destroy($id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        $post->delete();

        return $this->success(null, 'Post deleted successfully');
    }
}


