<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductReaction extends Model
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
     * Get the reactionable model (product or comment).
     */
    public function reactionable()
    {
        return $this->morphTo();
    }

    /**
     * Get the product that owns the reaction.
     */
    public function product()
    {
        return $this->belongsTo(Product::class, 'reactionable_id')
            ->where('reactionable_type', Product::class);
    }

    /**
     * Get the comment that owns the reaction.
     */
    public function comment()
    {
        return $this->belongsTo(ProductComment::class, 'reactionable_id')
            ->where('reactionable_type', ProductComment::class);
    }
}
