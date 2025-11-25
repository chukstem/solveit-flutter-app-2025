import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/school.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/admin/data/models/requests/posts/create_category.dart';
import 'package:solveit/features/admin/data/models/requests/posts/create_permission.dart';
import 'package:solveit/features/admin/data/models/requests/posts/create_post.dart';
import 'package:solveit/features/admin/data/models/requests/posts/delete_post_or_category.dart';
import 'package:solveit/features/admin/data/models/requests/posts/update_post.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_department.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_faculty.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_level.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_school.dart';
import 'package:solveit/features/admin/data/models/requests/school/get_school_elements.dart';
import 'package:solveit/features/admin/data/models/responses/permissions/response.dart';
import 'package:solveit/features/admin/data/models/responses/posts/create_category.dart';
import 'package:solveit/features/admin/data/models/responses/posts/create_post.dart';
import 'package:solveit/features/admin/data/models/responses/posts/update_post.dart';
import 'package:solveit/features/admin/data/models/responses/roles/response.dart';
import 'package:solveit/features/admin/data/models/responses/school/create_level.dart';
import 'package:solveit/features/admin/data/models/responses/school/create_school.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/login.dart';
import 'package:solveit/features/school/data/models/responses/get_departments.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/features/school/data/models/responses/get_schools.dart';
import 'package:solveit/features/school/data/models/responses/level.dart';

/// **Administration State**
class AdminState {
  final bool isLoading;
  final String? errorMessage;
  final Failure? failure;
  final String selectedSection;

  // Response objects
  final GenericSchoolElementResponse? createSchoolResponse;
  final CreateLevelResponse? createLevelResponse;
  final CategoryResponse? createCategoryResponse;
  final PostResponse? createPostResponse;
  final UpdateOrDeletePostElementResponse? updatePostResponse;
  final UpdateOrDeletePostElementResponse? deletePostResponse;
  final CreateRolesResponse? createRoleResponse;
  final CreatePermissionResponse? createPermissionResponse;
  final GetRolesResponse? rolesResponse;
  final GetPermissionResponse? permissionsResponse;
  final AllSchoolsResponse? schoolsResponse;
  final AllFacultiesResponse? facultiesResponse;
  final AllDepartmentsResponse? departmentsResponse;
  final AllLevelsResponse? levelsResponse;
  final CategoryResponse? categoriesResponse;

  AdminState({
    this.isLoading = false,
    this.errorMessage,
    this.failure,
    this.selectedSection = 'dashboard',
    this.createSchoolResponse,
    this.createLevelResponse,
    this.createCategoryResponse,
    this.createPostResponse,
    this.updatePostResponse,
    this.deletePostResponse,
    this.createRoleResponse,
    this.createPermissionResponse,
    this.rolesResponse,
    this.permissionsResponse,
    this.schoolsResponse,
    this.facultiesResponse,
    this.departmentsResponse,
    this.levelsResponse,
    this.categoriesResponse,
  });

  AdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
    String? selectedSection,
    GenericSchoolElementResponse? createSchoolResponse,
    CreateLevelResponse? createLevelResponse,
    CategoryResponse? createCategoryResponse,
    PostResponse? createPostResponse,
    UpdateOrDeletePostElementResponse? updatePostResponse,
    UpdateOrDeletePostElementResponse? deletePostResponse,
    CreateRolesResponse? createRoleResponse,
    CreatePermissionResponse? createPermissionResponse,
    GetRolesResponse? rolesResponse,
    GetPermissionResponse? permissionsResponse,
    AllSchoolsResponse? schoolsResponse,
    AllFacultiesResponse? facultiesResponse,
    AllDepartmentsResponse? departmentsResponse,
    AllLevelsResponse? levelsResponse,
    CategoryResponse? categoriesResponse,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      selectedSection: selectedSection ?? this.selectedSection,
      createSchoolResponse: createSchoolResponse ?? this.createSchoolResponse,
      createLevelResponse: createLevelResponse ?? this.createLevelResponse,
      createCategoryResponse: createCategoryResponse ?? this.createCategoryResponse,
      createPostResponse: createPostResponse ?? this.createPostResponse,
      updatePostResponse: updatePostResponse ?? this.updatePostResponse,
      deletePostResponse: deletePostResponse ?? this.deletePostResponse,
      createRoleResponse: createRoleResponse ?? this.createRoleResponse,
      createPermissionResponse: createPermissionResponse ?? this.createPermissionResponse,
      rolesResponse: rolesResponse ?? this.rolesResponse,
      permissionsResponse: permissionsResponse ?? this.permissionsResponse,
      schoolsResponse: schoolsResponse ?? this.schoolsResponse,
      facultiesResponse: facultiesResponse ?? this.facultiesResponse,
      departmentsResponse: departmentsResponse ?? this.departmentsResponse,
      levelsResponse: levelsResponse ?? this.levelsResponse,
      categoriesResponse: categoriesResponse ?? this.categoriesResponse,
    );
  }
}

/// **AdminViewModel for Administration Management**
class AdminViewModel extends ChangeNotifier {
  AdminState _state = AdminState();
  AdminState get state => _state;

  // Request objects
  CreateSchoolRequest? createSchoolRequest;
  CreateLevel? createLevelRequest;
  CreateFacultyRequest? createFacultyRequest;
  CreateDepartmentRequest? createDepartmentRequest;
  CategoryRequest? createCategoryRequest;
  PostRequest? createPostRequest;
  UpdatePostRequest? updatePostRequest;
  DeletePostOrCategory? deletePostRequest;
  RoleRequest? createRoleRequest;
  PermissionRequest? createPermissionRequest;
  GetSchoolElements? getSchoolElementsRequest;

  /// ✅ **Handles API calls and updates state**
  Future<bool> _handleApiCall(Future<Either<Failure, dynamic>> Function() apiCall) async {
    _setState(isLoading: true);
    _clearErrors();

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (success) {
          _handleSuccess(success);
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(isLoading: false);
    }
  }

  void _handleSuccess(dynamic response) {
    if (response is GenericSchoolElementResponse) {
      _setState(createSchoolResponse: response);
    } else if (response is CreateLevelResponse) {
      _setState(createLevelResponse: response);
    } else if (response is CategoryResponse) {
      if (_state.selectedSection == 'categories') {
        _setState(categoriesResponse: response);
      } else {
        _setState(createCategoryResponse: response);
      }
    } else if (response is PostResponse) {
      _setState(createPostResponse: response);
    } else if (response is UpdateOrDeletePostElementResponse) {
      if (_state.selectedSection == 'updatePost') {
        _setState(updatePostResponse: response);
      } else {
        _setState(deletePostResponse: response);
      }
    } else if (response is CreateRolesResponse) {
      _setState(createRoleResponse: response);
    } else if (response is CreatePermissionResponse) {
      _setState(createPermissionResponse: response);
    } else if (response is GetRolesResponse) {
      _setState(rolesResponse: response);
    } else if (response is GetPermissionResponse) {
      _setState(permissionsResponse: response);
    } else if (response is AllSchoolsResponse) {
      _setState(schoolsResponse: response);
    } else if (response is AllFacultiesResponse) {
      _setState(facultiesResponse: response);
    } else if (response is AllDepartmentsResponse) {
      _setState(departmentsResponse: response);
    } else if (response is AllLevelsResponse) {
      _setState(levelsResponse: response);
    }
    _clearRequests();
  }

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
    String? selectedSection,
    GenericSchoolElementResponse? createSchoolResponse,
    CreateLevelResponse? createLevelResponse,
    CategoryResponse? createCategoryResponse,
    PostResponse? createPostResponse,
    UpdateOrDeletePostElementResponse? updatePostResponse,
    UpdateOrDeletePostElementResponse? deletePostResponse,
    CreateRolesResponse? createRoleResponse,
    CreatePermissionResponse? createPermissionResponse,
    GetRolesResponse? rolesResponse,
    GetPermissionResponse? permissionsResponse,
    AllSchoolsResponse? schoolsResponse,
    AllFacultiesResponse? facultiesResponse,
    AllDepartmentsResponse? departmentsResponse,
    AllLevelsResponse? levelsResponse,
    CategoryResponse? categoriesResponse,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      errorMessage: errorMessage,
      failure: failure,
      selectedSection: selectedSection,
      createSchoolResponse: createSchoolResponse,
      createLevelResponse: createLevelResponse,
      createCategoryResponse: createCategoryResponse,
      createPostResponse: createPostResponse,
      updatePostResponse: updatePostResponse,
      deletePostResponse: deletePostResponse,
      createRoleResponse: createRoleResponse,
      createPermissionResponse: createPermissionResponse,
      rolesResponse: rolesResponse,
      permissionsResponse: permissionsResponse,
      schoolsResponse: schoolsResponse,
      facultiesResponse: facultiesResponse,
      departmentsResponse: departmentsResponse,
      levelsResponse: levelsResponse,
      categoriesResponse: categoriesResponse,
    );
    Timer(const Duration(milliseconds: 30), () => notifyListeners());
  }

  /// ✅ **Clears error messages and failure objects**
  void _clearErrors() {
    _setState(
      errorMessage: null,
      failure: null,
    );
  }

  /// ✅ **Sets error information**
  void _setError(Failure failure) {
    _setState(errorMessage: failure.message, failure: failure);
  }

  /// ✅ **Clears all request objects**
  void _clearRequests() {
    createSchoolRequest = null;
    createLevelRequest = null;
    createFacultyRequest = null;
    createDepartmentRequest = null;
    createCategoryRequest = null;
    createPostRequest = null;
    updatePostRequest = null;
    deletePostRequest = null;
    createRoleRequest = null;
    createPermissionRequest = null;
    getSchoolElementsRequest = null;
  }

  // School Management Methods
  Future<bool> createSchool() async =>
      _handleApiCall(() => adminService.createSchool(createSchoolRequest!));

  Future<bool> createLevel() async =>
      _handleApiCall(() => adminService.createLevel(createLevelRequest!));

  Future<bool> createFaculty() async =>
      _handleApiCall(() => adminService.createFaculty(createFacultyRequest!));

  Future<bool> createDepartment() async =>
      _handleApiCall(() => adminService.createDepartment(createDepartmentRequest!));

  // School Management Convenience Methods
  Future<bool> createSchoolWithName(String name) async {
    createSchoolRequest = CreateSchoolRequest(name: name);
    return createSchool();
  }

  Future<bool> createFacultyWithDetails({
    required String name,
    required String schoolId,
  }) async {
    createFacultyRequest = CreateFacultyRequest(
      name: name,
      schoolId: schoolId,
    );
    return createFaculty();
  }

  Future<bool> createDepartmentWithDetails({
    required String name,
    required String schoolId,
    required String facultyId,
  }) async {
    createDepartmentRequest = CreateDepartmentRequest(
      name: name,
      schoolId: schoolId,
      facultyId: facultyId,
    );
    return createDepartment();
  }

  Future<bool> createLevelWithDetails({
    required String name,
    required String schoolId,
  }) async {
    createLevelRequest = CreateLevel(
      name: name,
      schoolId: schoolId,
    );
    return createLevel();
  }

  // School Data Retrieval Methods
  Future<bool> getSchools() async {
    getSchoolElementsRequest = GetSchoolElements(elementType: 'School');
    return _handleApiCall(() => schoolService.getSchools(getSchoolElementsRequest!));
  }

  Future<bool> getFaculties() async {
    getSchoolElementsRequest = GetSchoolElements(elementType: 'Faculty');
    return _handleApiCall(() => schoolService.getFaculties(getSchoolElementsRequest!));
  }

  Future<bool> getDepartments() async {
    getSchoolElementsRequest = GetSchoolElements(elementType: 'Department');
    return _handleApiCall(() => schoolService.getDepartments(getSchoolElementsRequest!));
  }

  Future<bool> getLevels() async {
    getSchoolElementsRequest = GetSchoolElements(elementType: 'Level');
    return _handleApiCall(() => schoolService.getLevels(getSchoolElementsRequest!));
  }

  // Load initial data
  Future<void> loadSchoolData() async {
    await getSchools();
    await getFaculties();
    await getDepartments();
    await getLevels();
  }

  // Post Management Methods
  Future<bool> createCategory() async =>
      _handleApiCall(() => adminService.createCategory(createCategoryRequest!));

  Future<bool> createPost() async =>
      _handleApiCall(() => adminService.createPost(createPostRequest!));

  Future<bool> updatePost() async =>
      _handleApiCall(() => adminService.updatePost(updatePostRequest!));

  Future<bool> deletePostElement() async =>
      _handleApiCall(() => adminService.deletePostElement(deletePostRequest!));

  // Role and Permission Management Methods
  Future<bool> createRole() async =>
      _handleApiCall(() => adminService.createRole(createRoleRequest!));

  Future<bool> createPermission() async =>
      _handleApiCall(() => adminService.createPermission(createPermissionRequest!));

  Future<bool> getRoles() async => _handleApiCall(() => adminService.getRoles());

  Future<bool> getPermissions() async => _handleApiCall(() => adminService.getPermission());

  // Auth Methods
  Future<bool> login({required String email, required String password}) async {
    _setState(isLoading: true);
    _clearErrors();

    try {
      final result = await authService.login(LoginRequest(password: password, email: email), true);
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (token) {
          // Store the token and other user data if needed
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(isLoading: false);
    }
  }

  // Navigation Methods
  void selectSection(String section) {
    _setState(selectedSection: section);
  }

  /// ✅ **Clears all state data**
  void clearSession() {
    _clearRequests();
    _clearErrors();
    _setState(
      createSchoolResponse: null,
      createLevelResponse: null,
      createCategoryResponse: null,
      createPostResponse: null,
      updatePostResponse: null,
      deletePostResponse: null,
      createRoleResponse: null,
      createPermissionResponse: null,
      rolesResponse: null,
      permissionsResponse: null,
      schoolsResponse: null,
      facultiesResponse: null,
      departmentsResponse: null,
      levelsResponse: null,
      categoriesResponse: null,
    );
  }
}
