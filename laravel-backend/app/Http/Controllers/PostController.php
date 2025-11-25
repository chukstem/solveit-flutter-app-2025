<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\PostCategory;
use App\Models\Comment;
use App\Models\Reaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class PostController extends Controller
{
    /**
     * Get all posts with pagination and filters.
     */
    public function getPosts(Request $request)
    {
        $query = Post::with(['user', 'school', 'category', 'comments', 'reactions', 'media'])
            ->where('is_published', true);

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('news_category_id', $request->category_id);
        }

        // Filter by school
        if ($request->has('school_id')) {
            $query->where('school_id', $request->school_id);
        }

        // Filter by user
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Search
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('body', 'like', "%{$search}%")
                  ->orWhere('tags', 'like', "%{$search}%");
            });
        }

        // Sort
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $posts = $query->paginate(20);

        return $this->success($posts);
    }

    /**
     * Get a single post by ID.
     */
    public function getPost($id)
    {
        $post = Post::with(['user', 'school', 'category', 'comments.user', 'comments.media', 'reactions.user', 'media'])
            ->find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Increment views count
        $post->increment('views_count');

        return $this->success($post);
    }

    /**
     * Create a new post.
     */
    public function createPost(Request $request)
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
            'media' => 'nullable|array',
            'media.*' => 'file|mimes:jpeg,png,jpg,gif,mp4,avi,mov|max:10240',
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
            'code' => \Str::random(10),
            'is_published' => true,
            'published_at' => now(),
        ]);

        // Handle media uploads
        if ($request->hasFile('media')) {
            foreach ($request->file('media') as $file) {
                $post->addMedia($file)->toMediaCollection('media');
            }
        }

        return $this->success($post->load(['user', 'school', 'category', 'media']), 'Post created successfully');
    }

    /**
     * Update a post.
     */
    public function updatePost(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if user can update this post
        if ($post->user_id !== auth()->id() && !auth()->user()->hasRole('admin')) {
            return $this->forbidden('You can only update your own posts');
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
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $post->update($request->only([
            'news_category_id', 'title', 'excerpt', 'body', 'tags',
            'faculties', 'departments', 'levels', 'interests',
            'featured', 'enable_comments', 'enable_reactions'
        ]));

        // Handle image updates if provided
        if ($request->has('images')) {
            // Delete existing images
            $post->images()->delete();
            
            // Add new images
            foreach ($request->images as $index => $imageUrl) {
                $post->images()->create([
                    'image_url' => $imageUrl,
                    'order' => $index,
                ]);
            }
        }

        return $this->success($post->load(['user', 'school', 'category', 'images']), 'Post updated successfully');
    }

    /**
     * Delete a post.
     */
    public function deletePost($id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if user can delete this post
        if ($post->user_id !== auth()->id() && !auth()->user()->hasRole('admin')) {
            return $this->forbidden('You can only delete your own posts');
        }

        $post->delete();

        return $this->success(null, 'Post deleted successfully');
    }

    /**
     * Get all post categories.
     */
    public function getCategories()
    {
        $categories = PostCategory::where('is_active', true)->get();
        return $this->success($categories);
    }

    /**
     * Create a post category.
     */
    public function createCategory(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'color' => 'nullable|string|max:7',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $category = PostCategory::create($request->all());

        return $this->success($category, 'Category created successfully');
    }

    /**
     * Add a comment to a post.
     */
    public function addComment(Request $request, $postId)
    {
         

        $validator = Validator::make($request->all(), [
            'body' => 'required|string',
            'parent_id' => 'nullable|exists:comments,id',
            'media' => 'nullable|array',
            'media.*' => 'file|mimes:jpeg,png,jpg,gif,mp4,mp3,pdf,doc,docx,wav,m4a|max:20480',
        ]);

        if ($validator->fails()) {
            \Log::error('Validation failed for addComment', ['errors' => $validator->errors()->toArray()]);
            return $this->validationError($validator->errors());
        }

        $post = Post::find($postId);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        if (!$post->enable_comments) {
            return $this->error('Comments are disabled for this post', 403);
        }

        try {
            $comment = Comment::create([
                'user_id' => auth()->id(),
                'post_id' => $postId,
                'parent_id' => $request->parent_id,
                'body' => $request->body,
            ]);

            // Handle media uploads
            if ($request->hasFile('media')) {
                \Log::info('Processing ' . count($request->file('media')) . ' media files for comment ' . $comment->id);
                
                foreach ($request->file('media') as $file) {
                    \Log::info('Adding media: ' . $file->getClientOriginalName() . ' (MIME: ' . $file->getMimeType() . ')');
                    $comment->addMedia($file)->toMediaCollection('media');
                }
                
                \Log::info('Successfully added media to comment ' . $comment->id);
            }

            return $this->success($comment->load(['user.verification', 'media']), 'Comment added successfully');
        } catch (\Exception $e) {
            \Log::error('Error adding comment: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());
            return $this->error('Failed to add comment: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Get comments for a post.
     */
    public function getComments($postId)
    {
        $userId = auth()->id();
        
        $comments = Comment::with(['user.verification', 'children.user.verification', 'children.media', 'likes', 'media'])
            ->where('post_id', $postId)
            ->whereNull('parent_id')
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        // Add like information for current user
        $comments->getCollection()->transform(function ($comment) use ($userId) {
            $comment->is_liked = $comment->isLikedBy($userId);
            $comment->like_count = $comment->like_count;
            return $comment;
        });

        return $this->success($comments);
    }

    /**
     * Get replies for a specific comment.
     */
    public function getCommentReplies($commentId)
    {
        $userId = auth()->id();
        
        $comment = Comment::with(['user.verification', 'likes'])->find($commentId);
        if (!$comment) {
            return $this->notFound('Comment not found');
        }

        // Add like information for the parent comment
        $comment->is_liked = $comment->isLikedBy($userId);
        $comment->like_count = $comment->like_count;

        $replies = Comment::with(['user.verification', 'likes'])
            ->where('parent_id', $commentId)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        // Add like information for current user
        $replies->getCollection()->transform(function ($reply) use ($userId) {
            $reply->is_liked = $reply->isLikedBy($userId);
            $reply->like_count = $reply->like_count;
            return $reply;
        });

        return $this->success([
            'comment' => $comment,
            'replies' => $replies,
        ]);
    }

    /**
     * Add a reaction to a post.
     */
    public function addReaction(Request $request, $postId)
    {
        $validator = Validator::make($request->all(), [
            'type' => 'required|string|in:like,love,laugh,angry,sad',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $post = Post::find($postId);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        if (!$post->enable_reactions) {
            return $this->error('Reactions are disabled for this post', 403);
        }

        // Remove existing reaction from this user
        Reaction::where('user_id', auth()->id())
            ->where('reactionable_id', $postId)
            ->where('reactionable_type', Post::class)
            ->delete();

        // Add new reaction
        $reaction = Reaction::create([
            'user_id' => auth()->id(),
            'reactionable_id' => $postId,
            'reactionable_type' => Post::class,
            'type' => $request->type,
        ]);

        // Check if current user has saved this post
        $isSaved = auth()->user()
            ->savedPosts()
            ->where('post_id', $postId)
            ->exists();

        return $this->success([
            'reaction' => $reaction,
            'is_liked' => true,
            'is_saved' => $isSaved,
        ], 'Reaction added successfully');
    }

    /**
     * Remove a reaction from a post.
     */
    public function removeReaction($postId)
    {
        $post = Post::find($postId);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Remove existing reaction from this user
        Reaction::where('user_id', auth()->id())
            ->where('reactionable_id', $postId)
            ->where('reactionable_type', Post::class)
            ->delete();

        // Check if current user has saved this post
        $isSaved = auth()->user()
            ->savedPosts()
            ->where('post_id', $postId)
            ->exists();

        return $this->success([
            'is_liked' => false,
            'is_saved' => $isSaved,
        ], 'Reaction removed successfully');
    }

    /**
     * Get reactions for a post.
     */
    public function getReactions($postId)
    {
        $reactions = Reaction::with('user')
            ->where('reactionable_id', $postId)
            ->where('reactionable_type', Post::class)
            ->get();

        // Check if current user has saved this post
        $isSaved = auth()->user()
            ->savedPosts()
            ->where('post_id', $postId)
            ->exists();

        return $this->success([
            'reactions' => $reactions,
            'is_saved' => $isSaved,
        ]);
    }

    /**
     * Save/bookmark a post.
     */
    public function savePost($postId)
    {
        $post = Post::find($postId);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if already saved
        $existingSave = auth()->user()->savedPosts()->where('post_id', $postId)->first();

        // Check if user has liked this post
        $isLiked = Reaction::where('user_id', auth()->id())
            ->where('reactionable_id', $postId)
            ->where('reactionable_type', Post::class)
            ->exists();

        if ($existingSave) {
            // Unsave/unbookmark
            auth()->user()->savedPosts()->detach($postId);
            return $this->success([
                'is_saved' => false,
                'is_liked' => $isLiked,
            ], 'Post removed from bookmarks');
        } else {
            // Save/bookmark
            auth()->user()->savedPosts()->attach($postId, [
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            return $this->success([
                'is_saved' => true,
                'is_liked' => $isLiked,
            ], 'Post bookmarked successfully');
        }
    }

    /**
     * Get user's saved posts.
     */
    public function getSavedPosts()
    {
        $savedPosts = auth()->user()
            ->savedPosts()
            ->with(['user', 'school', 'category'])
            ->orderBy('saved_posts.created_at', 'desc')
            ->paginate(20);

        return $this->success($savedPosts);
    }

    /**
     * Like a comment.
     */
    public function likeComment($commentId)
    {
        $comment = Comment::find($commentId);

        if (!$comment) {
            return $this->notFound('Comment not found');
        }

        $userId = auth()->id();

        // Check if already liked
        $existingLike = $comment->likes()->where('user_id', $userId)->exists();

        if ($existingLike) {
            return $this->error('Comment already liked', 400);
        }

        // Add like
        $comment->likes()->attach($userId);

        return $this->success([
            'is_liked' => true,
            'like_count' => $comment->like_count,
        ], 'Comment liked successfully');
    }

    /**
     * Unlike a comment.
     */
    public function unlikeComment($commentId)
    {
        $comment = Comment::find($commentId);

        if (!$comment) {
            return $this->notFound('Comment not found');
        }

        $userId = auth()->id();

        // Remove like
        $comment->likes()->detach($userId);

        return $this->success([
            'is_liked' => false,
            'like_count' => $comment->like_count,
        ], 'Comment unliked successfully');
    }

    /**
     * Update a comment.
     */
    public function updateComment(Request $request, $commentId)
    {
        $validator = Validator::make($request->all(), [
            'body' => 'required|string|max:1000',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $comment = Comment::find($commentId);

        if (!$comment) {
            return $this->notFound('Comment not found');
        }

        // Check if user owns the comment
        if ($comment->user_id !== auth()->id()) {
            return $this->error('You can only edit your own comments', 403);
        }

        $comment->update([
            'body' => $request->body,
        ]);

        return $this->success($comment->load('user'), 'Comment updated successfully');
    }

    /**
     * Delete a comment.
     */
    public function deleteComment($commentId)
    {
        $comment = Comment::find($commentId);

        if (!$comment) {
            return $this->notFound('Comment not found');
        }

        // Check if user owns the comment or is the post author
        $post = $comment->post;
        $canDelete = $comment->user_id === auth()->id() || 
                     ($post && $post->user_id === auth()->id());

        if (!$canDelete) {
            return $this->error('You can only delete your own comments or comments on your posts', 403);
        }

        $comment->delete();

        return $this->success(null, 'Comment deleted successfully');
    }
    
    /**
     * Search posts with query, category, and filters.
     */
    public function searchPosts(Request $request)
    {
        $query = Post::with(['user', 'school', 'category', 'comments', 'reactions'])
            ->where('is_published', true);

        // Search by query (title, body, tags)
        if ($request->has('query') && !empty($request->input('query'))) {
            $searchTerm = $request->input('query');
            $query->where(function($q) use ($searchTerm) {
                $q->where('title', 'LIKE', "%{$searchTerm}%")
                  ->orWhere('body', 'LIKE', "%{$searchTerm}%")
                  ->orWhere('tags', 'LIKE', "%{$searchTerm}%");
            });
        }

        // Filter by category
        if ($request->has('category_id') && !empty($request->category_id)) {
            $query->where('news_category_id', $request->category_id);
        }

        // Filter by category name
        if ($request->has('category') && !empty($request->category)) {
            $query->whereHas('category', function($q) use ($request) {
                $q->where('name', 'LIKE', "%{$request->category}%");
            });
        }

        // Filter by date range
        if ($request->has('date_filter')) {
            $dateFilter = $request->date_filter;
            $now = now();

            switch ($dateFilter) {
                case 'this_week':
                    $query->whereBetween('created_at', [$now->startOfWeek(), $now->endOfWeek()]);
                    break;
                case 'last_week':
                    $query->whereBetween('created_at', [
                        $now->copy()->subWeek()->startOfWeek(),
                        $now->copy()->subWeek()->endOfWeek()
                    ]);
                    break;
                case 'this_month':
                    $query->whereMonth('created_at', $now->month)
                          ->whereYear('created_at', $now->year);
                    break;
                case 'last_month':
                    $query->whereMonth('created_at', $now->copy()->subMonth()->month)
                          ->whereYear('created_at', $now->copy()->subMonth()->year);
                    break;
                case 'this_year':
                    $query->whereYear('created_at', $now->year);
                    break;
                case 'last_year':
                    $query->whereYear('created_at', $now->copy()->subYear()->year);
                    break;
            }
        }

        // Custom date range
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [$request->start_date, $request->end_date]);
        }

        // Filter by post type
        if ($request->has('post_type')) {
            $postType = $request->post_type;

            switch ($postType) {
                case 'featured':
                    $query->where('featured', true);
                    break;
                case 'trending':
                    // Posts with high engagement in last 7 days
                    $query->where('created_at', '>=', now()->subDays(7))
                          ->withCount(['comments', 'reactions'])
                          ->orderByDesc('reactions_count')
                          ->orderByDesc('comments_count');
                    break;
                case 'hot':
                    // Posts with high engagement in last 24 hours
                    $query->where('created_at', '>=', now()->subDay())
                          ->withCount(['comments', 'reactions'])
                          ->orderByDesc('reactions_count')
                          ->orderByDesc('comments_count');
                    break;
                case 'recommended':
                    // Posts from user's school or categories
                    if ($request->user()) {
                        $query->where(function($q) use ($request) {
                            $q->where('school_id', $request->user()->school_id)
                              ->orWhere('news_category_id', $request->user()->interests);
                        });
                    }
                    break;
            }
        }

        // Default ordering
        if (!$request->has('post_type') || $request->post_type === 'all') {
            $query->orderBy('created_at', 'desc');
        }

        $posts = $query->paginate($request->get('per_page', 20));

        return $this->success($posts);
    }

    /**
     * Add an image to a post.
     */
    public function addPostImage(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if user can update this post
        if ($post->user_id !== auth()->id() && !auth()->user()->hasRole('admin')) {
            return $this->forbidden('You can only update your own posts');
        }

        $validator = Validator::make($request->all(), [
            'image_url' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Get the next order number
        $maxOrder = $post->images()->max('order') ?? -1;

        $image = $post->images()->create([
            'image_url' => $request->image_url,
            'order' => $maxOrder + 1,
        ]);

        return $this->success($image, 'Image added successfully');
    }

    /**
     * Remove an image from a post.
     */
    public function removePostImage($postId, $imageId)
    {
        $post = Post::find($postId);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if user can update this post
        if ($post->user_id !== auth()->id() && !auth()->user()->hasRole('admin')) {
            return $this->forbidden('You can only update your own posts');
        }

        $image = $post->images()->find($imageId);

        if (!$image) {
            return $this->notFound('Image not found');
        }

        // Check if this is the last image
        if ($post->images()->count() === 1) {
            return $this->validationError(['error' => 'Cannot remove the last image. Posts must have at least one image.']);
        }

        $image->delete();

        // Reorder remaining images
        $post->images()->orderBy('order')->get()->each(function ($img, $index) {
            $img->update(['order' => $index]);
        });

        return $this->success(null, 'Image removed successfully');
    }

    /**
     * Reorder post images.
     */
    public function reorderPostImages(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return $this->notFound('Post not found');
        }

        // Check if user can update this post
        if ($post->user_id !== auth()->id() && !auth()->user()->hasRole('admin')) {
            return $this->forbidden('You can only update your own posts');
        }

        $validator = Validator::make($request->all(), [
            'image_ids' => 'required|array',
            'image_ids.*' => 'required|integer|exists:post_images,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Update order for each image
        foreach ($request->image_ids as $index => $imageId) {
            $post->images()->where('id', $imageId)->update(['order' => $index]);
        }

        return $this->success($post->load('images'), 'Images reordered successfully');
    }
}


