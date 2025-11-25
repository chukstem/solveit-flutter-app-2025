import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/school.dart';
import 'package:solveit/features/admin/data/models/requests/school/get_school_elements.dart';
import 'package:solveit/features/school/data/models/responses/get_departments.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/features/school/data/models/responses/get_schools.dart';
import 'package:solveit/features/school/data/models/responses/level.dart';

class SchoolState {
  bool isLoading;
  String errorMessage;
  AllSchoolsResponse? schoolResponse;
  AllFacultiesResponse? facultyResponse;
  AllDepartmentsResponse? departmentResponse;
  AllLevelsResponse? levelsResponse;
  String? facultyId;
  String? departmentId;
  String? levelId;
  String? schoolId;

  SchoolState({
    this.isLoading = false,
    this.errorMessage = '',
    this.schoolResponse,
    this.facultyResponse,
    this.departmentResponse,
    this.levelsResponse,
    this.facultyId,
    this.departmentId,
    this.levelId,
    this.schoolId,
  });

  SchoolState copyWith({
    bool? isLoading,
    String? errorMessage,
    AllSchoolsResponse? schoolResponse,
    AllFacultiesResponse? facultyResponse,
    AllDepartmentsResponse? departmentResponse,
    AllLevelsResponse? levelsResponse,
    String? facultyId,
    String? departmentId,
    String? levelId,
    String? schoolId,
  }) {
    return SchoolState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      schoolResponse: schoolResponse ?? this.schoolResponse,
      facultyResponse: facultyResponse ?? this.facultyResponse,
      departmentResponse: departmentResponse ?? this.departmentResponse,
      levelsResponse: levelsResponse ?? this.levelsResponse,
      facultyId: facultyId ?? this.facultyId,
      departmentId: departmentId ?? this.departmentId,
      levelId: levelId ?? this.levelId,
      schoolId: schoolId ?? this.schoolId,
    );
  }

  static final empty = SchoolState();
}

class SchoolViewModel extends ChangeNotifier {
  SchoolState _state = SchoolState.empty;
  SchoolState get state => _state;

  SchoolViewModel();

  void _setState(SchoolState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  String get errorMessage => _state.errorMessage;
  AllSchoolsResponse? get schoolResponse => _state.schoolResponse;
  AllFacultiesResponse? get facultyResponse => _state.facultyResponse;
  AllDepartmentsResponse? get departmentResponse => _state.departmentResponse;
  AllLevelsResponse? get levelsResponse => _state.levelsResponse;
  String? get facultyId => _state.facultyId;
  String? get departmentId => _state.departmentId;
  String? get levelId => _state.levelId;
  String? get schoolId => _state.schoolId;

  /// Handles API calls, loading state, and error handling
  Future<bool> _handleApiCall<T>(
      Future<dynamic> Function() apiCall, void Function(T) onSuccess) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: ''));

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setState(_state.copyWith(
            isLoading: false,
            errorMessage: failure.toString(),
          ));
          return false;
        },
        (response) {
          onSuccess(response);
          _setState(_state.copyWith(isLoading: false));
          return true;
        },
      );
    } catch (e) {
      _setState(_state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  void getAllschoolElements() {
    getDepartments();
    getFaculties();
    getLevels();
    getSchools();
  }

  ///Fetch Schools
  Future<bool> getSchools() async {
    return _handleApiCall<AllSchoolsResponse>(
      () => schoolService.getSchools(GetSchoolElements(elementType: 'School')),
      (response) {
        _setState(_state.copyWith(schoolResponse: response));
      },
    );
  }

  ///Fetch Faculties
  Future<bool> getFaculties() async {
    return _handleApiCall<AllFacultiesResponse>(
      () => schoolService.getFaculties(GetSchoolElements(elementType: 'Faculty')),
      (response) {
        _setState(_state.copyWith(facultyResponse: response));
      },
    );
  }

  ///Fetch Departments
  Future<bool> getDepartments() async {
    return _handleApiCall<AllDepartmentsResponse>(
      () => schoolService.getDepartments(GetSchoolElements(elementType: 'Department')),
      (response) {
        _setState(_state.copyWith(departmentResponse: response));
      },
    );
  }

  Future<bool> getLevels() async {
    return _handleApiCall<AllLevelsResponse>(
      () => schoolService.getLevels(GetSchoolElements(elementType: 'Level')),
      (response) {
        _setState(_state.copyWith(levelsResponse: response));
      },
    );
  }

  // ID setters
  void setFacultyId(String id) {
    _setState(_state.copyWith(facultyId: id));
  }

  void setDepartmentId(String id) {
    _setState(_state.copyWith(departmentId: id));
  }

  void setLevelId(String id) {
    _setState(_state.copyWith(levelId: id));
  }

  void setSchoolId(String id) {
    _setState(_state.copyWith(schoolId: id));
  }

  /// Clears stored data (useful on logout/reset)
  void clearData() {
    _setState(SchoolState.empty);
  }
}
