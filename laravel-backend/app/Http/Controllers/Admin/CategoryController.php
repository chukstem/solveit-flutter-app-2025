<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PostCategory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CategoryController extends Controller
{
    /**
     * Create a post category.
     */
    public function store(Request $request)
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
     * Update category.
     */
    public function update(Request $request, $id)
    {
        $category = PostCategory::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'color' => 'nullable|string|max:7',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $category->update($request->all());

        return $this->success($category, 'Category updated successfully');
    }

    /**
     * Delete category.
     */
    public function destroy($id)
    {
        $category = PostCategory::findOrFail($id);
        $category->delete();

        return $this->success(null, 'Category deleted successfully');
    }
}


