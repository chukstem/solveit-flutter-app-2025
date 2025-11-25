import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/school.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/admin/data/models/requests/school/get_school_elements.dart';
import 'package:solveit/features/school/data/models/responses/get_departments.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/features/school/data/models/responses/get_schools.dart';
import 'package:solveit/features/school/data/models/responses/level.dart';

abstract class SchoolService {
  Future<Either<Failure, AllSchoolsResponse>> getSchools(GetSchoolElements req);
  Future<Either<Failure, AllFacultiesResponse>> getFaculties(GetSchoolElements req);
  Future<Either<Failure, AllDepartmentsResponse>> getDepartments(GetSchoolElements req);
  Future<Either<Failure, AllLevelsResponse>> getLevels(GetSchoolElements req);
}

class SchoolServiceImplementation extends SchoolService {
  @override
  Future<Either<Failure, AllDepartmentsResponse>> getDepartments(req) {
    return schoolApi.getDepartments(req);
  }

  @override
  Future<Either<Failure, AllFacultiesResponse>> getFaculties(req) {
    return schoolApi.getFaculties(req);
  }

  @override
  Future<Either<Failure, AllSchoolsResponse>> getSchools(req) {
    return schoolApi.getSchools(req);
  }

  @override
  Future<Either<Failure, AllLevelsResponse>> getLevels(req) {
    return schoolApi.getLevels(req);
  }
}
