<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;
use App\Models\Permission;
use App\Models\School;
use App\Models\Faculty;
use App\Models\Department;
use App\Models\Level;
use App\Models\PostCategory;
use App\Models\ServiceCategory;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create roles
        $adminRole = Role::create([
            'name' => 'admin',
            'display_name' => 'Administrator',
            'description' => 'Full system access',
        ]);

        $studentRole = Role::create([
            'name' => 'student',
            'display_name' => 'Student',
            'description' => 'Student user',
        ]);

        $staffRole = Role::create([
            'name' => 'staff',
            'display_name' => 'Staff',
            'description' => 'Staff member',
        ]);

        $lecturerRole = Role::create([
            'name' => 'lecturer',
            'display_name' => 'Lecturer',
            'description' => 'Lecturer/Teacher',
        ]);

        // Create permissions
        $permissions = [
            'create_posts',
            'edit_posts',
            'delete_posts',
            'manage_users',
            'manage_schools',
            'manage_categories',
            'manage_services',
            'manage_products',
            'view_analytics',
        ];

        foreach ($permissions as $permission) {
            Permission::create([
                'name' => $permission,
                'display_name' => ucwords(str_replace('_', ' ', $permission)),
                'description' => 'Permission to ' . str_replace('_', ' ', $permission),
            ]);
        }

        // Assign all permissions to admin role
        $adminRole->permissions()->attach(Permission::all());

        // Create sample school
        $school = School::create([
            'name' => 'University of Lagos',
            'code' => 'UNILAG',
            'address' => 'Akoka, Lagos',
            'city' => 'Lagos',
            'state' => 'Lagos',
            'country' => 'Nigeria',
            'phone' => '+234-1-234-5678',
            'email' => 'info@unilag.edu.ng',
            'website' => 'https://unilag.edu.ng',
        ]);

        // Create faculties
        $engineering = Faculty::create([
            'name' => 'Engineering',
            'code' => 'ENG',
            'school_id' => $school->id,
        ]);

        $science = Faculty::create([
            'name' => 'Science',
            'code' => 'SCI',
            'school_id' => $school->id,
        ]);

        $arts = Faculty::create([
            'name' => 'Arts',
            'code' => 'ART',
            'school_id' => $school->id,
        ]);

        $socialSciences = Faculty::create([
            'name' => 'Social Sciences',
            'code' => 'SOC',
            'school_id' => $school->id,
        ]);

        // Create departments for Engineering
        Department::create([
            'name' => 'Computer Science',
            'code' => 'CSC',
            'school_id' => $school->id,
            'faculty_id' => $engineering->id,
        ]);

        Department::create([
            'name' => 'Electrical Engineering',
            'code' => 'EEE',
            'school_id' => $school->id,
            'faculty_id' => $engineering->id,
        ]);

        Department::create([
            'name' => 'Mechanical Engineering',
            'code' => 'MEE',
            'school_id' => $school->id,
            'faculty_id' => $engineering->id,
        ]);

        Department::create([
            'name' => 'Civil Engineering',
            'code' => 'CVE',
            'school_id' => $school->id,
            'faculty_id' => $engineering->id,
        ]);

        // Create departments for Science
        Department::create([
            'name' => 'Mathematics',
            'code' => 'MAT',
            'school_id' => $school->id,
            'faculty_id' => $science->id,
        ]);

        Department::create([
            'name' => 'Physics',
            'code' => 'PHY',
            'school_id' => $school->id,
            'faculty_id' => $science->id,
        ]);

        Department::create([
            'name' => 'Chemistry',
            'code' => 'CHE',
            'school_id' => $school->id,
            'faculty_id' => $science->id,
        ]);

        Department::create([
            'name' => 'Biology',
            'code' => 'BIO',
            'school_id' => $school->id,
            'faculty_id' => $science->id,
        ]);

        // Create departments for Arts
        Department::create([
            'name' => 'English',
            'code' => 'ENG',
            'school_id' => $school->id,
            'faculty_id' => $arts->id,
        ]);

        Department::create([
            'name' => 'History',
            'code' => 'HIS',
            'school_id' => $school->id,
            'faculty_id' => $arts->id,
        ]);

        // Create departments for Social Sciences
        Department::create([
            'name' => 'Economics',
            'code' => 'ECO',
            'school_id' => $school->id,
            'faculty_id' => $socialSciences->id,
        ]);

        Department::create([
            'name' => 'Political Science',
            'code' => 'POL',
            'school_id' => $school->id,
            'faculty_id' => $socialSciences->id,
        ]);

        Department::create([
            'name' => 'Sociology',
            'code' => 'SOC',
            'school_id' => $school->id,
            'faculty_id' => $socialSciences->id,
        ]);

        // Create levels (for the first department as example)
        $firstDepartment = Department::first();
        if ($firstDepartment) {
            $levels = [
                ['name' => '100', 'code' => '100L'],
                ['name' => '200', 'code' => '200L'],
                ['name' => '300', 'code' => '300L'],
                ['name' => '400', 'code' => '400L'],
                ['name' => '500', 'code' => '500L'],
                ['name' => 'Graduate', 'code' => 'GRAD'],
            ];
            foreach ($levels as $levelData) {
                Level::create([
                    'name' => $levelData['name'],
                    'code' => $levelData['code'],
                    'department_id' => $firstDepartment->id,
                ]);
            }
        }

        // Create post categories
        $postCategories = [
            ['name' => 'News', 'description' => 'General news and updates', 'color' => '#83074E'],
            ['name' => 'Events', 'description' => 'Campus events and activities', 'color' => '#FF9900'],
            ['name' => 'Academic', 'description' => 'Academic announcements', 'color' => '#159919'],
            ['name' => 'Sports', 'description' => 'Sports and recreation', 'color' => '#F13918'],
            ['name' => 'Entertainment', 'description' => 'Entertainment and lifestyle', 'color' => '#FDAF3B'],
        ];

        foreach ($postCategories as $category) {
            PostCategory::create($category);
        }

        // Create service categories
        $serviceCategories = [
            ['name' => 'Tutoring', 'description' => 'Academic tutoring services', 'icon' => 'book'],
            ['name' => 'Transportation', 'description' => 'Transport and logistics', 'icon' => 'car'],
            ['name' => 'Food & Catering', 'description' => 'Food and catering services', 'icon' => 'utensils'],
            ['name' => 'Technology', 'description' => 'Tech support and services', 'icon' => 'laptop'],
            ['name' => 'Health & Wellness', 'description' => 'Health and wellness services', 'icon' => 'heart'],
        ];

        foreach ($serviceCategories as $category) {
            ServiceCategory::create($category);
        }
    }
}
