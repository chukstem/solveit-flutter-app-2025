<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Intervention\Image\Facades\Image;

class FileController extends Controller
{
    /**
     * Upload a file.
     */
    public function upload(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'file' => 'required|file|max:10240', // 10MB max
            'type' => 'required|string|in:avatar,post,product,service,message',
            'folder' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $file = $request->file('file');
        $type = $request->type;
        $folder = $request->folder ?? $type;

        // Validate file type based on upload type
        $allowedTypes = $this->getAllowedTypes($type);
        if (!in_array($file->getClientOriginalExtension(), $allowedTypes)) {
            return $this->error('File type not allowed for this upload type', 400);
        }

        // Generate unique filename
        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();
        $path = $file->storeAs($folder, $filename, 'public');

        // Create thumbnails for images
        if ($this->isImage($file)) {
            $this->createThumbnails($file, $path);
        }

        return $this->success([
            'filename' => $filename,
            'path' => $path,
            'url' => Storage::url($path),
            'size' => $file->getSize(),
            'mime_type' => $file->getMimeType(),
            'original_name' => $file->getClientOriginalName(),
        ], 'File uploaded successfully');
    }

    /**
     * Upload multiple files.
     */
    public function uploadMultiple(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'files' => 'required|array|max:10',
            'files.*' => 'required|file|max:10240',
            'type' => 'required|string|in:avatar,post,product,service,message',
            'folder' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $files = $request->file('files');
        $type = $request->type;
        $folder = $request->folder ?? $type;
        $uploadedFiles = [];

        foreach ($files as $file) {
            // Validate file type
            $allowedTypes = $this->getAllowedTypes($type);
            if (!in_array($file->getClientOriginalExtension(), $allowedTypes)) {
                continue; // Skip invalid files
            }

            // Generate unique filename
            $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs($folder, $filename, 'public');

            // Create thumbnails for images
            if ($this->isImage($file)) {
                $this->createThumbnails($file, $path);
            }

            $uploadedFiles[] = [
                'filename' => $filename,
                'path' => $path,
                'url' => Storage::url($path),
                'size' => $file->getSize(),
                'mime_type' => $file->getMimeType(),
                'original_name' => $file->getClientOriginalName(),
            ];
        }

        return $this->success($uploadedFiles, 'Files uploaded successfully');
    }

    /**
     * Delete a file.
     */
    public function delete(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $path = $request->path;

        // Check if file exists
        if (!Storage::disk('public')->exists($path)) {
            return $this->notFound('File not found');
        }

        // Delete file and thumbnails
        Storage::disk('public')->delete($path);
        $this->deleteThumbnails($path);

        return $this->success(null, 'File deleted successfully');
    }

    /**
     * Get file information.
     */
    public function info(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $path = $request->path;

        // Check if file exists
        if (!Storage::disk('public')->exists($path)) {
            return $this->notFound('File not found');
        }

        $fileInfo = [
            'path' => $path,
            'url' => Storage::url($path),
            'size' => Storage::disk('public')->size($path),
            'last_modified' => Storage::disk('public')->lastModified($path),
            'mime_type' => Storage::disk('public')->mimeType($path),
        ];

        return $this->success($fileInfo);
    }

    /**
     * Get allowed file types for upload type.
     */
    private function getAllowedTypes($type)
    {
        $allowedTypes = [
            'avatar' => ['jpg', 'jpeg', 'png', 'gif'],
            'post' => ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'avi', 'mov'],
            'product' => ['jpg', 'jpeg', 'png', 'gif'],
            'service' => ['jpg', 'jpeg', 'png', 'gif'],
            'message' => ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'avi', 'mov', 'mp3', 'wav', 'pdf', 'doc', 'docx', 'txt'],
        ];

        return $allowedTypes[$type] ?? ['jpg', 'jpeg', 'png', 'gif'];
    }

    /**
     * Check if file is an image.
     */
    private function isImage($file)
    {
        $imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
        return in_array(strtolower($file->getClientOriginalExtension()), $imageTypes);
    }

    /**
     * Create thumbnails for images.
     */
    private function createThumbnails($file, $path)
    {
        try {
            $image = Image::make($file);
            
            // Create thumbnail (150x150)
            $thumbnail = $image->resize(150, 150, function ($constraint) {
                $constraint->aspectRatio();
                $constraint->upsize();
            });
            
            $thumbnailPath = 'thumbnails/' . basename($path);
            $thumbnail->save(storage_path('app/public/' . $thumbnailPath));
            
            // Create medium size (300x300)
            $medium = $image->resize(300, 300, function ($constraint) {
                $constraint->aspectRatio();
                $constraint->upsize();
            });
            
            $mediumPath = 'medium/' . basename($path);
            $medium->save(storage_path('app/public/' . $mediumPath));
            
        } catch (\Exception $e) {
            // Log error but don't fail the upload
            \Log::error('Thumbnail creation failed: ' . $e->getMessage());
        }
    }

    /**
     * Delete thumbnails for a file.
     */
    private function deleteThumbnails($path)
    {
        $filename = basename($path);
        
        // Delete thumbnail
        $thumbnailPath = 'thumbnails/' . $filename;
        if (Storage::disk('public')->exists($thumbnailPath)) {
            Storage::disk('public')->delete($thumbnailPath);
        }
        
        // Delete medium size
        $mediumPath = 'medium/' . $filename;
        if (Storage::disk('public')->exists($mediumPath)) {
            Storage::disk('public')->delete($mediumPath);
        }
    }

    /**
     * Get file URL with thumbnail support.
     */
    public function getFileUrl(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
            'size' => 'nullable|string|in:original,medium,thumb',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $path = $request->path;
        $size = $request->get('size', 'original');

        // Check if file exists
        if (!Storage::disk('public')->exists($path)) {
            return $this->notFound('File not found');
        }

        $url = Storage::url($path);

        // Return appropriate size
        if ($size === 'thumb') {
            $thumbPath = 'thumbnails/' . basename($path);
            if (Storage::disk('public')->exists($thumbPath)) {
                $url = Storage::url($thumbPath);
            }
        } elseif ($size === 'medium') {
            $mediumPath = 'medium/' . basename($path);
            if (Storage::disk('public')->exists($mediumPath)) {
                $url = Storage::url($mediumPath);
            }
        }

        return $this->success(['url' => $url]);
    }
}
