<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class GeneralController extends Controller
{
    /**
     * Get Nigeria states and LGAs.
     */
    public function getStates()
    {
        $cacheKey = 'nigeria_states';
        $cacheDuration = 24 * 60; // 24 hours
        
        $states = Cache::remember($cacheKey, $cacheDuration, function () {
            try {
                $response = Http::timeout(30)->get(env('NIGERIA_STATES_API_URL', 'https://nga-states-lga.onrender.com/fetch'));
                
                if ($response->successful()) {
                    return $response->json();
                }
                
                // Fallback data
                return $this->getFallbackStates();
            } catch (\Exception $e) {
                \Log::error('Failed to fetch states: ' . $e->getMessage());
                return $this->getFallbackStates();
            }
        });
        
        return $this->success($states);
    }

    /**
     * Get cities in a state.
     */
    public function getCities(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'state' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $state = $request->state;
        $cacheKey = "cities_{$state}";
        $cacheDuration = 24 * 60; // 24 hours
        
        $cities = Cache::remember($cacheKey, $cacheDuration, function () use ($state) {
            try {
                $response = Http::timeout(30)->get(env('NIGERIA_STATES_API_URL', 'https://nga-states-lga.onrender.com/fetch') . "/{$state}");
                
                if ($response->successful()) {
                    return $response->json();
                }
                
                return [];
            } catch (\Exception $e) {
                \Log::error('Failed to fetch cities: ' . $e->getMessage());
                return [];
            }
        });
        
        return $this->success($cities);
    }

    /**
     * Get app statistics.
     */
    public function getStats()
    {
        $cacheKey = 'app_stats';
        $cacheDuration = 60; // 1 hour
        
        $stats = Cache::remember($cacheKey, $cacheDuration, function () {
            return [
                'total_users' => \App\Models\User::count(),
                'total_posts' => \App\Models\Post::count(),
                'total_products' => \App\Models\Product::count(),
                'total_services' => \App\Models\Service::count(),
                'total_schools' => \App\Models\School::count(),
                'online_users' => $this->getOnlineUsersCount(),
            ];
        });
        
        return $this->success($stats);
    }

    /**
     * Get app version and info.
     */
    public function getAppInfo()
    {
        return $this->success([
            'name' => 'SolveIt API',
            'version' => '1.0.0',
            'build' => '1',
            'environment' => app()->environment(),
            'timestamp' => now()->toISOString(),
        ]);
    }

    /**
     * Search across the platform.
     */
    public function search(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'query' => 'required|string|min:2',
            'type' => 'nullable|string|in:posts,products,services,users,forums,schools,faculties,departments,levels,all',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Use input('query') to get the string parameter; $request->query is an InputBag
        $searchQuery = $request->input('query');
        $type = $request->input('type', 'all');
        $results = [];

        if ($type === 'all' || $type === 'posts') {
            $results['posts'] = \App\Models\Post::where('title', 'like', "%{$searchQuery}%")
                ->orWhere('body', 'like', "%{$searchQuery}%")
                ->with(['user', 'category'])
                ->limit(10)
                ->get();
        }

        if ($type === 'all' || $type === 'products') {
            $results['products'] = \App\Models\Product::where('name', 'like', "%{$searchQuery}%")
                ->orWhere('description', 'like', "%{$searchQuery}%")
                ->with(['user'])
                ->limit(10)
                ->get();
        }

        if ($type === 'all' || $type === 'services') {
            $results['services'] = \App\Models\Service::where('name', 'like', "%{$searchQuery}%")
                ->orWhere('description', 'like', "%{$searchQuery}%")
                ->with(['user', 'category'])
                ->limit(10)
                ->get();
        }

        if ($type === 'all' || $type === 'users') {
            $results['users'] = \App\Models\User::where('name', 'like', "%{$searchQuery}%")
                ->with(['school'])
                ->limit(10)
                ->get();
        }

        if ($type === 'all' || $type === 'forums') {
            $results['forums'] = \App\Models\Forum::where('name', 'like', "%{$searchQuery}%")
                ->with(['creator', 'category'])
                ->limit(10)
                ->get();
        }

        if ($type === 'all' || $type === 'schools') {
            $results['schools'] = \App\Models\School::where('name', 'like', "%{$searchQuery}%")
                ->limit(10)
                ->get(['id','name','code']);
        }

        if ($type === 'all' || $type === 'faculties') {
            $results['faculties'] = \App\Models\Faculty::where('name', 'like', "%{$searchQuery}%")
                ->with('school:id,name')
                ->limit(10)
                ->get(['id','name','school_id']);
        }

        if ($type === 'all' || $type === 'departments') {
            $results['departments'] = \App\Models\Department::where('name', 'like', "%{$searchQuery}%")
                ->with(['faculty:id,name,school_id','faculty.school:id,name'])
                ->limit(10)
                ->get(['id','name','faculty_id']);
        }

        if ($type === 'all' || $type === 'levels') {
            $results['levels'] = \App\Models\Level::where('name', 'like', "%{$searchQuery}%")
                ->limit(10)
                ->get(['id','name']);
        }

        return $this->success($results);
    }

    /**
     * Get fallback states data.
     */
    private function getFallbackStates()
    {
        return [
            ['name' => 'Lagos', 'code' => 'LA'],
            ['name' => 'Abuja', 'code' => 'FC'],
            ['name' => 'Kano', 'code' => 'KN'],
            ['name' => 'Rivers', 'code' => 'RI'],
            ['name' => 'Ogun', 'code' => 'OG'],
            ['name' => 'Oyo', 'code' => 'OY'],
            ['name' => 'Kaduna', 'code' => 'KD'],
            ['name' => 'Edo', 'code' => 'ED'],
            ['name' => 'Delta', 'code' => 'DT'],
            ['name' => 'Imo', 'code' => 'IM'],
        ];
    }

    /**
     * Get online users count.
     */
    private function getOnlineUsersCount()
    {
        // This would typically check Redis or database for online users
        // For now, return a mock count
        return rand(50, 200);
    }
}
