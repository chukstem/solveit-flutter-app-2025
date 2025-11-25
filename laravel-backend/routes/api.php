<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\MarketController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\Admin\SchoolController as AdminSchoolController;
use App\Http\Controllers\Admin\UserController as AdminUserController;
use App\Http\Controllers\Admin\ForumController as AdminForumController;
use App\Http\Controllers\Admin\RoleController as AdminRoleController;
use App\Http\Controllers\Admin\DashboardController as AdminDashboardController;
use App\Http\Controllers\Admin\PostController as AdminPostController;
use App\Http\Controllers\Admin\CategoryController as AdminCategoryController;
use App\Http\Controllers\FileController;
use App\Http\Controllers\ForumController;
use App\Http\Controllers\Admin\NotificationController as AdminNotificationController;
use App\Http\Controllers\Admin\FcmController as AdminFcmController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\GeneralController;
use App\Http\Controllers\WebSocketController;
use App\Http\Controllers\BroadcastingAuthController;
use App\Http\Controllers\VerificationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::prefix('v1')->group(function () {
    
    // Authentication routes
    Route::prefix('auth')->group(function () {
        Route::post('login', [AuthController::class, 'login']);
        Route::post('register', [AuthController::class, 'register']);
        Route::post('verify-email', [AuthController::class, 'verifyEmail']);
        Route::post('resend-code', [AuthController::class, 'resendCode']);
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
        Route::post('reset-password', [AuthController::class, 'resetPassword']);
    });

    // User routes
    Route::prefix('user')->group(function () {
        Route::get('getAllUsers', [AuthController::class, 'getAllUsers']);
        Route::get('getUserProfile/{id}', [AuthController::class, 'getUserProfile']);
    });

    // General routes
    Route::get('uploads/{file}', function ($file) {
        return response()->file(storage_path('app/public/' . $file));
    });
    
    // General endpoints
    Route::get('general/retrieveFile/{file}', [GeneralController::class, 'getFileUrl']);
    Route::get('general/getAllStates', [GeneralController::class, 'getStates']);
    Route::get('general/getAllCityInStates', [GeneralController::class, 'getCities']);
    Route::get('general/stats', [GeneralController::class, 'getStats']);
    Route::get('general/app-info', [GeneralController::class, 'getAppInfo']);
    Route::get('general/search', [GeneralController::class, 'search']);
    
    // Public roles endpoint for signup
    Route::get('admin/roles/getRoles', [AdminRoleController::class, 'index']);
    
    // Public school elements endpoint for signup (allow both GET and POST)
    Route::match(['get','post'], 'admin/school/getSchoolElements', [AdminSchoolController::class, 'getSchoolElements']);

    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {
        
        // Authentication routes
    Route::prefix('auth')->group(function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
        Route::post('logout-all', [AuthController::class, 'logoutAll']);
        Route::get('profile/refresh', [AuthController::class, 'refreshProfile']);
        Route::get('profile/forums', [AuthController::class, 'getUserForums']);
        Route::put('profile/update-level', [AuthController::class, 'updateLevel']);
        
        // Settings routes
        Route::get('settings', [AuthController::class, 'getSettings']);
        Route::put('settings', [AuthController::class, 'updateSettings']);
        Route::post('delete-account', [AuthController::class, 'deleteAccount']);
        Route::post('change-password', [AuthController::class, 'changePassword']);
        Route::post('update-fcm-token', [AuthController::class, 'updateFcmToken']);
        
        // Avatar routes
        Route::post('update-avatar', [AuthController::class, 'updateAvatar']);
        Route::delete('delete-avatar', [AuthController::class, 'deleteAvatar']);
    });
        
        // School elements (public for authenticated users)
        Route::get('school/levels', [AdminSchoolController::class, 'getAllLevels']);

        // Posts routes (all protected)
        Route::prefix('posts')->group(function () {
            Route::get('getPostElements', [PostController::class, 'getPosts']);
            Route::get('searchPosts', [PostController::class, 'searchPosts']);
            Route::get('getPostElements/{id}', [PostController::class, 'getPost']);
            Route::post('createPost', [PostController::class, 'createPost']);
            Route::put('updatePost/{id}', [PostController::class, 'updatePost']);
            Route::delete('deletePost/{id}', [PostController::class, 'deletePost']);
            Route::get('getCategories', [PostController::class, 'getCategories']);
            Route::post('createCategory', [PostController::class, 'createCategory']);
            Route::post('createPostComment/{postId}', [PostController::class, 'addComment']);
            Route::get('getComments/{postId}', [PostController::class, 'getComments']);
            Route::get('getCommentReplies/{commentId}', [PostController::class, 'getCommentReplies']);
            Route::post('likeComment/{commentId}', [PostController::class, 'likeComment']);
            Route::delete('unlikeComment/{commentId}', [PostController::class, 'unlikeComment']);
            Route::put('updateComment/{commentId}', [PostController::class, 'updateComment']);
            Route::delete('deleteComment/{commentId}', [PostController::class, 'deleteComment']);
            Route::post('createPostReaction/{postId}', [PostController::class, 'addReaction']);
            Route::delete('deletePostReaction/{postId}', [PostController::class, 'removeReaction']);
            Route::get('getReactions/{postId}', [PostController::class, 'getReactions']);
            Route::post('savePost/{postId}', [PostController::class, 'savePost']);
            Route::get('getSavedPosts', [PostController::class, 'getSavedPosts']);
            
            // Post images routes
            Route::post('{postId}/images', [PostController::class, 'addPostImage']);
            Route::delete('{postId}/images/{imageId}', [PostController::class, 'removePostImage']);
            Route::put('{postId}/images/reorder', [PostController::class, 'reorderPostImages']);
        });

        // Market routes
        Route::prefix('market-place')->group(function () {
            Route::get('getMarketElement', [MarketController::class, 'getProducts']);
            Route::get('getMarketElement/{id}', [MarketController::class, 'getProduct']);
            Route::post('createProduct', [MarketController::class, 'createProduct']);
            Route::put('updateProduct/{id}', [MarketController::class, 'updateProduct']);
            Route::delete('deleteMarketElement/{id}', [MarketController::class, 'deleteProduct']);
            Route::post('createProductTag', [MarketController::class, 'createTags']);
            Route::put('updateProductTag/{id}', [MarketController::class, 'updateTags']);
            Route::post('createProductComment', [MarketController::class, 'addComment']);
            Route::get('getComments/{productId}', [MarketController::class, 'getComments']);
            Route::post('createProductCommentReaction', [MarketController::class, 'addReaction']);
            Route::get('getReactions/{productId}', [MarketController::class, 'getReactions']);
        });

        // Service routes
        Route::prefix('core-services')->group(function () {
            Route::get('getCoreServices', [ServiceController::class, 'getServices']);
            Route::get('getCoreServices/{id}', [ServiceController::class, 'getService']);
            Route::post('createCoreService', [ServiceController::class, 'createService']);
            Route::put('updateCoreService/{id}', [ServiceController::class, 'updateService']);
            Route::delete('deleteCoreService/{id}', [ServiceController::class, 'deleteService']);
            Route::get('getCoreServiceCategories', [ServiceController::class, 'getCategories']);
            Route::post('createCoreServiceCategory', [ServiceController::class, 'createCategory']);
            Route::post('createCoreServiceBooking', [ServiceController::class, 'bookService']);
            Route::get('getCoreServiceBookings', [ServiceController::class, 'getBookings']);
            Route::put('updateCoreServiceBookingStatus/{id}', [ServiceController::class, 'updateBookingStatus']);
            Route::post('createCoreServiceRating', [ServiceController::class, 'rateService']);
            Route::get('getCoreServiceRatings/{serviceId}', [ServiceController::class, 'getRatings']);
            Route::post('createCoreServicePayment', [ServiceController::class, 'createPayment']);
            Route::get('getCoreServicePayments', [ServiceController::class, 'getPayments']);
            Route::put('updateCoreServicePaymentStatus/{id}', [ServiceController::class, 'updatePaymentStatus']);
        });

        // Message routes
    // Contacts Routes
    Route::post('contacts/check', [ContactController::class, 'checkContacts']);
    
    Route::prefix('messages')->group(function () {
        Route::get('conversations', [MessageController::class, 'getConversations']);
            Route::get('conversations/{id}/messages', [MessageController::class, 'getMessages']);
            Route::post('send', [MessageController::class, 'sendMessage']);
            Route::post('conversations/find-or-create', [MessageController::class, 'findOrCreatePrivateConversation']);
            Route::post('conversations/group', [MessageController::class, 'createGroupConversation']);
            Route::post('typing', [MessageController::class, 'typingIndicator']);
            Route::post('whisper', [MessageController::class, 'handleWhisper']);
            Route::post('conversations/{id}/participants', [MessageController::class, 'addParticipants']);
            Route::delete('conversations/{id}/participants', [MessageController::class, 'removeParticipants']);
            Route::post('conversations/{id}/read', [MessageController::class, 'markAsRead']);
            Route::post('messages/{id}/delivered', [MessageController::class, 'markAsDelivered']);
            Route::post('messages/delivered', [MessageController::class, 'markMessagesAsDelivered']);
            Route::put('messages/{id}', [MessageController::class, 'updateMessage']);
            Route::delete('messages/{id}', [MessageController::class, 'deleteMessage']);
            Route::get('unread-count', [MessageController::class, 'getUnreadCount']);
            Route::get('search', [MessageController::class, 'searchMessages']);
        });

        // Admin routes
        Route::prefix('admin')->middleware('role:admin')->group(function () {
            
            // Users management (for Admin UI)
            Route::prefix('users')->group(function () {
                Route::get('/', [AdminUserController::class, 'index']);
                Route::get('{id}', [AdminUserController::class, 'show']);
                Route::put('{id}', [AdminUserController::class, 'update']);
                Route::post('{id}/toggle-status', [AdminUserController::class, 'toggleStatus']);
                Route::delete('{id}', [AdminUserController::class, 'destroy']);
                Route::post('{id}/restore', [AdminUserController::class, 'restore']);
            });

            // Forums management (for Admin UI)
            Route::prefix('forums')->group(function () {
                Route::get('/', [AdminForumController::class, 'index']);
                Route::get('{id}', [AdminForumController::class, 'show']);
                Route::put('{id}', [AdminForumController::class, 'update']);
                Route::delete('{id}', [AdminForumController::class, 'destroy']);
            });

            // School management
            Route::prefix('school')->group(function () {
                Route::post('createSchool', [AdminSchoolController::class, 'storeSchool']);
                Route::post('createFaculty', [AdminSchoolController::class, 'storeFaculty']);
                Route::get('faculty/{schoolId}', [AdminSchoolController::class, 'getFaculties']);
                Route::post('createDepartment', [AdminSchoolController::class, 'storeDepartment']);
                Route::get('department/{facultyId}', [AdminSchoolController::class, 'getDepartments']);
                Route::post('createLevel', [AdminSchoolController::class, 'storeLevel']);

                // Additional admin endpoints used by the Admin UI pages
                Route::put('schools/{id}', [AdminSchoolController::class, 'updateSchool']);
                Route::delete('schools/{id}', [AdminSchoolController::class, 'deleteSchool']);
                Route::put('faculties/{id}', [AdminSchoolController::class, 'updateFaculty']);
                Route::delete('faculties/{id}', [AdminSchoolController::class, 'deleteFaculty']);
                Route::put('departments/{id}', [AdminSchoolController::class, 'updateDepartment']);
                Route::delete('departments/{id}', [AdminSchoolController::class, 'deleteDepartment']);
            });

            // Mirror endpoints without the extra "school" prefix to match Admin UI
            Route::put('schools/{id}', [AdminSchoolController::class, 'updateSchool']);
            Route::delete('schools/{id}', [AdminSchoolController::class, 'deleteSchool']);
            Route::put('faculties/{id}', [AdminSchoolController::class, 'updateFaculty']);
            Route::delete('faculties/{id}', [AdminSchoolController::class, 'deleteFaculty']);
            Route::put('departments/{id}', [AdminSchoolController::class, 'updateDepartment']);
            Route::delete('departments/{id}', [AdminSchoolController::class, 'deleteDepartment']);

            // Post management
            Route::prefix('post')->group(function () {
                Route::post('createPost', [AdminPostController::class, 'store']);
                Route::put('updatePost/{id}', [AdminPostController::class, 'update']);
                Route::delete('deletePost/{id}', [AdminPostController::class, 'destroy']);
            });

            // Category management
            Route::prefix('category')->group(function () {
                Route::post('createPostCategory', [AdminCategoryController::class, 'store']);
            });

            // Role and permission management
            Route::prefix('roles')->group(function () {
                Route::post('createRole', [AdminRoleController::class, 'store']);
                Route::get('getPermissions', [AdminRoleController::class, 'getPermissions']);
                Route::post('createPermission', [AdminRoleController::class, 'storePermission']);
                // Added: update/delete role and assign role to user
                Route::put('{id}', [AdminRoleController::class, 'update']);
                Route::delete('{id}', [AdminRoleController::class, 'destroy']);
                Route::post('assignRole', [AdminRoleController::class, 'assignRole']);
            });

            // Dashboard
            Route::get('dashboard', [AdminDashboardController::class, 'getStats']);

            // Admin notifications (specific admin path)
            Route::get('admin-notifications', [AdminNotificationController::class, 'index']);

            // Send Push (FCM)
            Route::post('push/send', [AdminFcmController::class, 'sendPush']);

            // Verification management
            Route::prefix('verification')->group(function () {
                Route::get('pending', [VerificationController::class, 'getPendingVerifications']);
                Route::get('all', [VerificationController::class, 'getAllVerifications']);
                Route::get('stats', [VerificationController::class, 'getVerificationStats']);
                Route::get('user/{userId}', [VerificationController::class, 'getUserVerificationDetails']);
                Route::put('update-status', [VerificationController::class, 'updateVerificationStatus']);
                Route::put('bulk-update', [VerificationController::class, 'bulkUpdateVerificationStatus']);
            });
        });

        // File management routes
        Route::prefix('files')->group(function () {
            Route::post('upload', [FileController::class, 'upload']);
            Route::post('upload-multiple', [FileController::class, 'uploadMultiple']);
            Route::delete('delete', [FileController::class, 'delete']);
            Route::get('info', [FileController::class, 'info']);
            Route::get('url', [FileController::class, 'getFileUrl']);
        });
 

        // Notification routes
        Route::prefix('notifications')->group(function () {
            Route::get('/', [NotificationController::class, 'index']);
            Route::get('unread-count', [NotificationController::class, 'unreadCount']);
            Route::post('/', [NotificationController::class, 'store']); // For testing
            Route::put('mark-as-read/{id}', [NotificationController::class, 'markAsRead']);
            Route::put('mark-all-as-read', [NotificationController::class, 'markAllAsRead']);
            Route::delete('{id}', [NotificationController::class, 'destroy']);
            Route::delete('/', [NotificationController::class, 'deleteAll']);
        });
        // Forum routes
        Route::prefix('forums')->group(function () {
            Route::get('/', [ForumController::class, 'index']);
            Route::post('/', [ForumController::class, 'store']);
            Route::get('search', [ForumController::class, 'search']);
            Route::get('unread-count', [ForumController::class, 'getTotalUnreadCount']);
            Route::get('{id}', [ForumController::class, 'show']);
            Route::put('{id}', [ForumController::class, 'update']);
            Route::delete('{id}', [ForumController::class, 'destroy']);
            
            // Forum membership
            Route::post('{id}/join', [ForumController::class, 'join']);
            Route::post('{id}/leave', [ForumController::class, 'leave']);
            Route::post('{id}/toggle-mute', [ForumController::class, 'toggleMute']);
            Route::post('{id}/mark-as-read', [ForumController::class, 'markAsRead']);
            Route::get('{id}/members', [ForumController::class, 'getMembers']);
            Route::get('{id}/media', [ForumController::class, 'getMedia']);
            
            // Admin and Moderator operations
            Route::post('{id}/remove-member', [ForumController::class, 'removeMember']);
            Route::post('{id}/make-moderator', [ForumController::class, 'makeModerator']);
            Route::post('{id}/remove-moderator', [ForumController::class, 'removeModerator']);
            Route::post('{id}/make-admin', [ForumController::class, 'makeAdmin']);
            Route::post('{id}/remove-admin', [ForumController::class, 'removeAdmin']);
            
            // Forum messages
            Route::get('{id}/messages', [ForumController::class, 'getMessages']);
            Route::post('{id}/messages', [ForumController::class, 'sendMessage']);
            Route::put('messages/{messageId}', [ForumController::class, 'updateMessage']);
            Route::delete('messages/{messageId}', [ForumController::class, 'deleteMessage']);
        });

        // User Verification routes (protected)
        Route::prefix('verification')->group(function () {
            Route::get('status', [VerificationController::class, 'getVerificationStatus']);
            Route::post('bvn', [VerificationController::class, 'submitBvnVerification']);
            Route::post('id-card', [VerificationController::class, 'submitIdCardVerification']);
            Route::post('selfie', [VerificationController::class, 'submitSelfieVerification']);
        });

        // WebSocket routes
        Route::prefix('websocket')->group(function () {
            Route::post('user-online', [WebSocketController::class, 'userOnline']);
            Route::post('user-offline', [WebSocketController::class, 'userOffline']);
            Route::get('online-users', [WebSocketController::class, 'getOnlineUsers']);
            Route::post('join-channel', [WebSocketController::class, 'joinChannel']);
            Route::post('leave-channel', [WebSocketController::class, 'leaveChannel']);
        });
    });
});

// Broadcasting authentication - Custom route for API token authentication
// Standard Broadcast::routes() uses stateful middleware which doesn't work with Bearer tokens
Route::post('broadcasting/auth', [BroadcastingAuthController::class, 'authenticate']);

// Diagnostic endpoint to test broadcasting auth (can be removed after debugging)
Route::any('broadcasting/test', function (\Illuminate\Http\Request $request) {
    return response()->json([
        'message' => 'Broadcasting auth test endpoint',
        'method' => $request->method(),
        'headers' => $request->headers->all(),
        'query' => $request->query(),
        'input' => $request->all(),
        'has_token_header' => $request->hasHeader('Authorization'),
        'has_token_query' => $request->has('token'),
    ]);
});
