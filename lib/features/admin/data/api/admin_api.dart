import 'dart:developer';

import 'package:dartz/dartz.dart';
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
import 'package:solveit/features/admin/data/models/responses/permissions/response.dart';
import 'package:solveit/features/admin/data/models/responses/posts/create_category.dart';
import 'package:solveit/features/admin/data/models/responses/posts/create_post.dart';
import 'package:solveit/features/admin/data/models/responses/posts/update_post.dart';
import 'package:solveit/features/admin/data/models/responses/roles/response.dart';
import 'package:solveit/features/admin/data/models/responses/school/create_level.dart';
import 'package:solveit/features/admin/data/models/responses/school/create_school.dart';

abstract class AdminApi {
  Future<Either<Failure, GenericSchoolElementResponse>> createSchool(CreateSchoolRequest req);
  Future<Either<Failure, CreateLevelResponse>> createLevel(CreateLevel req);
  // Future<Either<Failure, SchoolResponse>> getSchoolElements(GetSchoolElements req);
  Future<Either<Failure, GenericSchoolElementResponse>> createFaculty(CreateFacultyRequest req);
  Future<Either<Failure, GenericSchoolElementResponse>> createDepartment(CreateDepartmentRequest req);
  Future<Either<Failure, CategoryResponse>> createCategory(CategoryRequest req);
  Future<Either<Failure, PostResponse>> createPost(PostRequest req);
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> updatePost(UpdatePostRequest req);
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> deletePostElement(DeletePostOrCategory req);

  Future<Either<Failure, CreateRolesResponse>> createRole(RoleRequest req);
  Future<Either<Failure, CreatePermissionResponse>> createPermission(PermissionRequest req);
  Future<Either<Failure, GetRolesResponse>> getRoles();
  Future<Either<Failure, GetPermissionResponse>> getPermission();
}

class AdminApiImplementation extends AdminApi {
  final ApiClient apiClient;

  AdminApiImplementation({required this.apiClient});

  /// **Generic helper for making API POST requests**
  Future<Either<ApiFailure, T>> _postRequest<T>(String url, dynamic req, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await apiClient.post(url, data: req.toMap());
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  Future<Either<ApiFailure, T>> _getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await apiClient.get(url);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, CategoryResponse>> createCategory(req) async {
    return _postRequest(adminEndpoints.createCategory, req, CategoryResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericSchoolElementResponse>> createDepartment(req) async {
    return _postRequest(adminEndpoints.createDepartment, req, GenericSchoolElementResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericSchoolElementResponse>> createFaculty(req) async {
    return _postRequest(adminEndpoints.createFaculty, req, GenericSchoolElementResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, PostResponse>> createPost(req) async {
    return _postRequest(adminEndpoints.createPost, req, PostResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericSchoolElementResponse>> createSchool(req) async {
    return _postRequest(adminEndpoints.createSchool, req, GenericSchoolElementResponse.fromMap);
  }

  @override
  Future<Either<Failure, CreatePermissionResponse>> createPermission(req) {
    return _postRequest(adminEndpoints.createPermission, req, CreatePermissionResponse.fromMap);
  }

  @override
  Future<Either<Failure, CreateRolesResponse>> createRole(req) {
    return _postRequest(adminEndpoints.createRole, req, CreateRolesResponse.fromMap);
  }

  @override
  Future<Either<Failure, GetPermissionResponse>> getPermission() {
    return _getRequest(adminEndpoints.getPermission, GetPermissionResponse.fromMap);
  }

  @override
  Future<Either<Failure, GetRolesResponse>> getRoles() {
    return _getRequest(adminEndpoints.getRoles, GetRolesResponse.fromMap);
  }

  @override
  Future<Either<Failure, CreateLevelResponse>> createLevel(CreateLevel req) {
    return _postRequest(adminEndpoints.createLevel, req, CreateLevelResponse.fromMap);
  }

  // @override
  // Future<Either<Failure, SchoolResponse>> getSchoolElements(req) {
  //   throw UnimplementedError();
  // }

  @override
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> deletePostElement(req) {
    return _postRequest(adminEndpoints.deletePost, req, UpdateOrDeletePostElementResponse.fromMap);
  }

  @override
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> updatePost(UpdatePostRequest req) {
    return _postRequest(adminEndpoints.updatePost, req, UpdateOrDeletePostElementResponse.fromMap);
  }
}
