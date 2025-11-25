<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Level extends Model
{
    use HasFactory;

    protected $fillable = [
        'department_id',
        'name',
        'code',
        'description',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    /**
     * Get the department that owns the level.
     */
    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    /**
     * Get the users that belong to this level.
     */
    public function users()
    {
        return $this->hasMany(User::class);
    }
}

