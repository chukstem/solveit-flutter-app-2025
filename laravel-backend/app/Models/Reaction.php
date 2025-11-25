<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'reactionable_id',
        'reactionable_type',
        'type',
    ];

    /**
     * Get the user that owns the reaction.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the reactionable model (post or comment).
     */
    public function reactionable()
    {
        return $this->morphTo();
    }

    /**
     * Get the post that owns the reaction.
     */
    public function post()
    {
        return $this->belongsTo(Post::class, 'reactionable_id')
            ->where('reactionable_type', Post::class);
    }

    /**
     * Get the comment that owns the reaction.
     */
    public function comment()
    {
        return $this->belongsTo(Comment::class, 'reactionable_id')
            ->where('reactionable_type', Comment::class);
    }
}
