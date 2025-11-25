<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\KycVerificationController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return redirect('/admin');
});

Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now(),
        'uptime' => 'running'
    ]);
});

// Admin Root Route
Route::get('/admin', function () {
    return view('admin.redirect');
})->name('admin.redirect');

// Admin Authentication Routes (Public)
Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/login', function () {
        return view('admin.auth.login');
    })->name('login');
    
    Route::get('/forgot-password', function () {
        return view('admin.auth.forgot-password');
    })->name('forgot-password');
    
    Route::post('/logout', function () {
        auth()->logout();
        return redirect('/admin/login');
    })->name('logout');
});

// Admin Panel Routes (Protected)
Route::prefix('admin')->name('admin.')->group(function () {
    
    // Dashboard
    Route::get('/dashboard', function () {
        return view('admin.dashboard');
    })->name('dashboard');

    // Users Management
    Route::prefix('users')->name('users.')->group(function () {
        Route::get('/', function () {
            return view('admin.users.index');
        })->name('index');
        Route::get('/{id}', function ($id) {
            return view('admin.users.show', ['id' => $id]);
        })->name('show');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.users.edit', ['id' => $id]);
        })->name('edit');
    });

    // Forums Management
    Route::prefix('forums')->name('forums.')->group(function () {
        Route::get('/', function () {
            return view('admin.forums.index');
        })->name('index');
        Route::get('/{id}', function ($id) {
            return view('admin.forums.show', ['id' => $id]);
        })->name('show');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.forums.edit', ['id' => $id]);
        })->name('edit');
    });

    // Posts Management
    Route::prefix('posts')->name('posts.')->group(function () {
        Route::get('/', function () {
            return view('admin.posts.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.posts.create');
        })->name('create');
        Route::get('/{id}', function ($id) {
            return view('admin.posts.show', ['id' => $id]);
        })->name('show');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.posts.edit', ['id' => $id]);
        })->name('edit');
        Route::get('/{id}/comments', function ($id) {
            return view('admin.posts.comments', ['id' => $id]);
        })->name('comments');
    });

    // School Elements
    Route::prefix('schools')->name('schools.')->group(function () {
        Route::get('/', function () {
            return view('admin.schools.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.schools.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.schools.edit', ['id' => $id]);
        })->name('edit');
    });

    Route::prefix('faculties')->name('faculties.')->group(function () {
        Route::get('/', function () {
            return view('admin.faculties.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.faculties.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.faculties.edit', ['id' => $id]);
        })->name('edit');
    });

    Route::prefix('departments')->name('departments.')->group(function () {
        Route::get('/', function () {
            return view('admin.departments.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.departments.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.departments.edit', ['id' => $id]);
        })->name('edit');
    });

    Route::prefix('levels')->name('levels.')->group(function () {
        Route::get('/', function () {
            return view('admin.levels.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.levels.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.levels.edit', ['id' => $id]);
        })->name('edit');
    });

    // Categories
    Route::prefix('categories')->name('categories.')->group(function () {
        Route::get('/', function () {
            return view('admin.categories.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.categories.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.categories.edit', ['id' => $id]);
        })->name('edit');
    });

    // Notifications
    Route::prefix('notifications')->name('notifications.')->group(function () {
        Route::get('/', function () {
            return view('admin.notifications.index');
        })->name('index');
        Route::get('/send', function () {
            return view('admin.notifications.send');
        })->name('send');
    });

    // Roles & Permissions
    Route::prefix('roles')->name('roles.')->group(function () {
        Route::get('/', function () {
            return view('admin.roles.index');
        })->name('index');
        Route::get('/create', function () {
            return view('admin.roles.create');
        })->name('create');
        Route::get('/{id}/edit', function ($id) {
            return view('admin.roles.edit', ['id' => $id]);
        })->name('edit');
        Route::get('/{id}/users', function ($id) {
            return view('admin.roles.users', ['id' => $id]);
        })->name('users');
    });

    Route::prefix('permissions')->name('permissions.')->group(function () {
        Route::get('/', function () {
            return view('admin.permissions.index');
        })->name('index');
    });

    // Admin KYC Verification Management
    Route::prefix('kyc')->name('kyc.')->group(function () {
        Route::get('/verifications', [KycVerificationController::class, 'index'])
            ->name('verifications');
        
        Route::get('/verification/user/{userId}', [KycVerificationController::class, 'viewUserDetails'])
            ->name('details');
    });
});
