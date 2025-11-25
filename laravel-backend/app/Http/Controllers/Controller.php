<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    /**
     * Return a success response
     */
    protected function success($data = null, $message = 'Success', $statusCode = 200)
    {
        return response()->json([
            'status' => $statusCode,
            'message' => $message,
            'data' => $data
        ], $statusCode);
    }

    /**
     * Return an error response
     */
    protected function error($message = 'Error', $statusCode = 400, $errors = null)
    {
        return response()->json([
            'status' => $statusCode,
            'message' => $message,
            'errors' => $errors
        ], $statusCode);
    }

    /**
     * Return a validation error response
     */
    protected function validationError($errors, $message = 'Validation failed')
    {
        return response()->json([
            'status' => 422,
            'message' => $message,
            'errors' => $errors
        ], 422);
    }

    /**
     * Return a not found response
     */
    protected function notFound($message = 'Resource not found')
    {
        return response()->json([
            'status' => 404,
            'message' => $message
        ], 404);
    }

    /**
     * Return an unauthorized response
     */
    protected function unauthorized($message = 'Unauthorized')
    {
        return response()->json([
            'status' => 401,
            'message' => $message
        ], 401);
    }

    /**
     * Return a forbidden response
     */
    protected function forbidden($message = 'Forbidden')
    {
        return response()->json([
            'status' => 403,
            'message' => $message
        ], 403);
    }
}
