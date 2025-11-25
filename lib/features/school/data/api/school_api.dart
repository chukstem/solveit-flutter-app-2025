import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/admin/data/models/requests/school/get_school_elements.dart';
import 'package:solveit/features/school/data/models/responses/get_departments.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/features/school/data/models/responses/get_schools.dart';
import 'package:solveit/features/school/data/models/responses/level.dart';

abstract class SchoolApi {
  Future<Either<Failure, AllSchoolsResponse>> getSchools(GetSchoolElements req);
  Future<Either<Failure, AllFacultiesResponse>> getFaculties(GetSchoolElements req);
  Future<Either<Failure, AllDepartmentsResponse>> getDepartments(GetSchoolElements req);
  Future<Either<Failure, AllLevelsResponse>> getLevels(GetSchoolElements req);
}

class SchoolApiImplementation extends SchoolApi {
  final ApiClient apiClient;

  SchoolApiImplementation({required this.apiClient});

  /// **Generic helper for making API GET requests**
  Future<Either<ApiFailure, T>> _getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.post(url, data: queryParameters);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in GET [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in GET [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, AllDepartmentsResponse>> getDepartments(req) async {
    return _getRequest(schoolEndpoints.getSchoolElements, AllDepartmentsResponse.fromMap, queryParameters: req.toMap());
  }

  @override
  Future<Either<ApiFailure, AllFacultiesResponse>> getFaculties(req) async {
    return _getRequest(schoolEndpoints.getSchoolElements, AllFacultiesResponse.fromMap, queryParameters: req.toMap());
  }

  @override
  Future<Either<ApiFailure, AllSchoolsResponse>> getSchools(req) async {
    return _getRequest(schoolEndpoints.getSchoolElements, AllSchoolsResponse.fromMap, queryParameters: req.toMap());
  }

  @override
  Future<Either<Failure, AllLevelsResponse>> getLevels(req) {
    return _getRequest(schoolEndpoints.getSchoolElements, AllLevelsResponse.fromMap, queryParameters: req.toMap());
  }
}
