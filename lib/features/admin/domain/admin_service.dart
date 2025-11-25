import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/admin.dart';
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

abstract class AdminService {
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

class AdminServiceImplementation extends AdminService {
  @override
  Future<Either<Failure, CategoryResponse>> createCategory(req) {
    return adminApi.createCategory(req);
  }

  @override
  Future<Either<Failure, GenericSchoolElementResponse>> createDepartment(req) {
    return adminApi.createDepartment(req);
  }

  @override
  Future<Either<Failure, GenericSchoolElementResponse>> createFaculty(req) {
    return adminApi.createFaculty(req);
  }

  @override
  Future<Either<Failure, PostResponse>> createPost(req) {
    return adminApi.createPost(req);
  }

  @override
  Future<Either<Failure, GenericSchoolElementResponse>> createSchool(req) {
    return adminApi.createSchool(req);
  }

  @override
  Future<Either<Failure, CreateLevelResponse>> createLevel(req) {
    return adminApi.createLevel(req);
  }

  @override
  Future<Either<Failure, CreatePermissionResponse>> createPermission(req) {
    return adminApi.createPermission(req);
  }

  @override
  Future<Either<Failure, CreateRolesResponse>> createRole(req) {
    return adminApi.createRole(req);
  }

  @override
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> deletePostElement(req) {
    return adminApi.deletePostElement(req);
  }

  @override
  Future<Either<Failure, GetPermissionResponse>> getPermission() {
    return adminApi.getPermission();
  }

  @override
  Future<Either<Failure, GetRolesResponse>> getRoles() {
    return adminApi.getRoles();
  }

  @override
  Future<Either<Failure, UpdateOrDeletePostElementResponse>> updatePost(UpdatePostRequest req) {
    return adminApi.updatePost(req);
  }
}
