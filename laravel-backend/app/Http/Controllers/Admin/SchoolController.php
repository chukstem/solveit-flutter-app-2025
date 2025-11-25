<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\School;
use App\Models\Faculty;
use App\Models\Department;
use App\Models\Level;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SchoolController extends Controller
{
    // ========== SCHOOL MANAGEMENT ==========
    
    /**
     * Create a new school.
     */
    public function storeSchool(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:schools',
            'address' => 'nullable|string',
            'city' => 'nullable|string',
            'state' => 'nullable|string',
            'country' => 'nullable|string',
            'phone' => 'nullable|string',
            'email' => 'nullable|email',
            'website' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $school = School::create($request->all());

        return $this->success($school, 'School created successfully');
    }

    /**
     * Get all schools.
     */
    public function getSchools(Request $request)
    {
        $schools = School::with(['faculties', 'users'])
            ->orderBy('name')
            ->paginate(20);

        return $this->success($schools);
    }

    /**
     * Update school.
     */
    public function updateSchool(Request $request, $id)
    {
        $school = School::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50|unique:schools,code,' . $id,
            'address' => 'nullable|string',
            'city' => 'nullable|string',
            'state' => 'nullable|string',
            'country' => 'nullable|string',
            'phone' => 'nullable|string',
            'email' => 'nullable|email',
            'website' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $school->update($request->all());

        return $this->success($school, 'School updated successfully');
    }

    /**
     * Delete school.
     */
    public function deleteSchool($id)
    {
        $school = School::findOrFail($id);
        
        // Check if school has users
        if ($school->users()->count() > 0) {
            return $this->error('Cannot delete school with active users', 400);
        }

        $school->delete();

        return $this->success(null, 'School deleted successfully');
    }

    // ========== FACULTY MANAGEMENT ==========
    
    /**
     * Create a new faculty.
     */
    public function storeFaculty(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'school_id' => 'required|exists:schools,id',
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $faculty = Faculty::create($request->all());

        return $this->success($faculty->load('school'), 'Faculty created successfully');
    }

    /**
     * Get faculties for a school.
     */
    public function getFaculties($schoolId)
    {
        $faculties = Faculty::with(['school', 'departments'])
            ->where('school_id', $schoolId)
            ->orderBy('name')
            ->get();

        return $this->success($faculties);
    }

    /**
     * Update faculty.
     */
    public function updateFaculty(Request $request, $id)
    {
        $faculty = Faculty::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'school_id' => 'sometimes|exists:schools,id',
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $faculty->update($request->all());

        return $this->success($faculty->load('school'), 'Faculty updated successfully');
    }

    /**
     * Delete faculty.
     */
    public function deleteFaculty($id)
    {
        $faculty = Faculty::findOrFail($id);
        $faculty->delete();

        return $this->success(null, 'Faculty deleted successfully');
    }

    // ========== DEPARTMENT MANAGEMENT ==========
    
    /**
     * Create a new department.
     */
    public function storeDepartment(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'faculty_id' => 'required|exists:faculties,id',
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $department = Department::create($request->all());

        return $this->success($department->load(['faculty.school']), 'Department created successfully');
    }

    /**
     * Get departments for a faculty.
     */
    public function getDepartments($facultyId)
    {
        $departments = Department::with(['faculty.school', 'levels'])
            ->where('faculty_id', $facultyId)
            ->orderBy('name')
            ->get();

        return $this->success($departments);
    }

    /**
     * Update department.
     */
    public function updateDepartment(Request $request, $id)
    {
        $department = Department::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'faculty_id' => 'sometimes|exists:faculties,id',
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $department->update($request->all());

        return $this->success($department->load(['faculty.school']), 'Department updated successfully');
    }

    /**
     * Delete department.
     */
    public function deleteDepartment($id)
    {
        $department = Department::findOrFail($id);
        $department->delete();

        return $this->success(null, 'Department deleted successfully');
    }

    // ========== LEVEL MANAGEMENT ==========
    
    /**
     * Create a new level.
     */
    public function storeLevel(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'department_id' => 'required|exists:departments,id',
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $level = Level::create($request->all());

        return $this->success($level->load(['department.faculty.school']), 'Level created successfully');
    }

    /**
     * Get all levels (for all users, not just admin)
     */
    public function getAllLevels()
    {
        $levels = Level::orderBy('name')->get();
        return $this->success($levels);
    }

    /**
     * Update level.
     */
    public function updateLevel(Request $request, $id)
    {
        $level = Level::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'department_id' => 'sometimes|exists:departments,id',
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $level->update($request->all());

        return $this->success($level->load(['department.faculty.school']), 'Level updated successfully');
    }

    /**
     * Delete level.
     */
    public function deleteLevel($id)
    {
        $level = Level::findOrFail($id);
        $level->delete();

        return $this->success(null, 'Level deleted successfully');
    }

    // ========== HIERARCHICAL DATA ==========
    
    /**
     * Get school elements (hierarchical structure).
     */
    public function getSchoolElements(Request $request)
    {
        $elementType = $request->input('elementType', 'School');
        
        switch ($elementType) {
            case 'School':
                $data = School::with([
                    'faculties.departments.levels',
                    'users' => function ($query) {
                        $query->select('id', 'name', 'email', 'school_id', 'faculty_id', 'department_id', 'level_id');
                    }
                ])->get();
                break;
                
            case 'Faculty':
                $data = Faculty::with(['departments.levels', 'school'])->get();
                break;
                
            case 'Department':
                $data = Department::with(['levels', 'faculty'])->get();
                break;
                
            case 'Level':
                $data = Level::all();
                break;
                
            default:
                return $this->error('Invalid element type', 400);
        }

        return $this->success($data);
    }
}


