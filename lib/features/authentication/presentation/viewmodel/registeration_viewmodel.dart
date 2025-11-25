// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/resend_code.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/signup.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/verify_email.dart';
import 'package:solveit/utils/utils/validators.dart';

enum LoginInputType { email, phone, password, password2, name, token, matric }

/// **Registration State Model**
class RegistrationState {
  // User information fields
  String role;
  String? school;
  String? schoolName;
  String? faculty;
  String? facultyName;
  String? department;
  String? departmentName;
  String? level;
  String? levelName;
  String? gender;
  String dateOfBirth;
  String matricNo;
  File? image;

  // Login credentials
  String email;
  String fullName;
  String phoneNumber;
  String password;
  String password2;

  // Validation errors
  final String? emailError;
  final String? fullNameError;
  final String? phoneNumberError;
  final String? passwordError;
  final String? password2Error;
  final String? matricNoError;

  // UI state
  bool accepted;
  LoginInputType inputType;

  RegistrationState({
    this.role = '',
    this.school,
    this.schoolName,
    this.faculty,
    this.facultyName,
    this.department,
    this.departmentName,
    this.level,
    this.levelName,
    this.gender,
    this.dateOfBirth = '',
    this.matricNo = '',
    this.image,
    this.email = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.password = '',
    this.password2 = '',
    this.emailError,
    this.fullNameError,
    this.phoneNumberError,
    this.passwordError,
    this.password2Error,
    this.matricNoError,
    this.accepted = false,
    this.inputType = LoginInputType.email,
  });

  // Helper methods
  bool get isStudentRole => role.toLowerCase() == '1';
  bool get isLecturerRole => role.toLowerCase() == '2';
  bool get isAdminRole => role.toLowerCase() == '3' || role.toLowerCase() == '4';

  bool canEnableSignupButton() {
    bool isBasicInfoValid = email.isNotEmpty &&
        fullName.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        password.isNotEmpty &&
        password2.isNotEmpty &&
        password == password2 &&
        gender != null &&
        dateOfBirth.isNotEmpty &&
        accepted;

    bool isRoleSpecificInfoValid = false;

    if (isStudentRole) {
      isRoleSpecificInfoValid = level != null &&
          role.isNotEmpty &&
          school != null &&
          faculty != null &&
          image != null &&
          matricNo.isNotEmpty;
    } else if (isLecturerRole) {
      isRoleSpecificInfoValid = role.isNotEmpty && school != null && faculty != null;
    } else if (isAdminRole) {
      isRoleSpecificInfoValid = role.isNotEmpty && school != null;
    }

    return isBasicInfoValid && isRoleSpecificInfoValid;
  }

  RegistrationState copyWith({
    String? role,
    String? school,
    String? schoolName,
    String? faculty,
    String? facultyName,
    String? department,
    String? departmentName,
    String? level,
    String? levelName,
    String? gender,
    String? dateOfBirth,
    String? matricNo,
    File? image,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? password,
    String? password2,
    String? emailError,
    String? fullNameError,
    String? phoneNumberError,
    String? passwordError,
    String? password2Error,
    String? matricNoError,
    bool? accepted,
    LoginInputType? inputType,
  }) {
    return RegistrationState(
      role: role ?? this.role,
      school: school ?? this.school,
      schoolName: schoolName ?? this.schoolName,
      faculty: faculty ?? this.faculty,
      facultyName: facultyName ?? this.facultyName,
      department: department ?? this.department,
      departmentName: departmentName ?? this.departmentName,
      level: level ?? this.level,
      levelName: levelName ?? this.levelName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      matricNo: matricNo ?? this.matricNo,
      image: image ?? this.image,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      password2: password2 ?? this.password2,
      emailError: emailError ?? this.emailError,
      fullNameError: fullNameError ?? this.fullNameError,
      phoneNumberError: phoneNumberError ?? this.phoneNumberError,
      passwordError: passwordError ?? this.passwordError,
      password2Error: password2Error ?? this.password2Error,
      matricNoError: matricNoError ?? this.matricNoError,
      accepted: accepted ?? this.accepted,
      inputType: inputType ?? this.inputType,
    );
  }
}

/// **RegistrationViewModel for User Registration Process**
class RegistrationViewModel extends ChangeNotifier {
  // State
  RegistrationState _state = RegistrationState();
  RegistrationState get state => _state;

  RegistrationViewModel();

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    String? role,
    String? school,
    String? schoolName,
    String? faculty,
    String? facultyName,
    String? department,
    String? departmentName,
    String? level,
    String? levelName,
    String? gender,
    String? dateOfBirth,
    String? matricNo,
    File? image,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? password,
    String? password2,
    String? emailError,
    String? fullNameError,
    String? phoneNumberError,
    String? passwordError,
    String? password2Error,
    String? matricNoError,
    bool? accepted,
    LoginInputType? inputType,
  }) {
    _state = _state.copyWith(
      role: role,
      school: school,
      schoolName: schoolName,
      faculty: faculty,
      facultyName: facultyName,
      department: department,
      departmentName: departmentName,
      level: level,
      levelName: levelName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      matricNo: matricNo,
      image: image,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
      password2: password2,
      emailError: emailError,
      fullNameError: fullNameError,
      phoneNumberError: phoneNumberError,
      passwordError: passwordError,
      password2Error: password2Error,
      matricNoError: matricNoError,
      accepted: accepted,
      inputType: inputType,
    );
    notifyListeners();
  }

  /// ✅ **Sets the selected input type for validation**
  void setInputType(LoginInputType type) {
    _setState(inputType: type);
  }

  /// ✅ **Toggles terms and conditions acceptance**
  void toggleAccepted(bool value) {
    _setState(accepted: value);
  }

  /// ✅ **Updates UI (used for misc. updates)**
  void updateUi() => notifyListeners();

  /// ✅ **Handles input validation and updates state**
  void onTextFieldChanged(String val) {
    // Validation based on input type
    switch (_state.inputType) {
      case LoginInputType.email:
        _setState(
          email: val,
          emailError: Validator.emailValidator(val),
        );
        break;
      case LoginInputType.phone:
        _setState(
          phoneNumber: val,
          phoneNumberError: Validator.phone(val),
        );
        break;
      case LoginInputType.password:
        _setState(
          password: val,
          passwordError: Validator.password(val),
        );
        if (_state.password2.isNotEmpty) {
          _setState(
            password2Error: Validator.confirmPassword(val, _state.password2),
          );
        }
        break;
      case LoginInputType.password2:
        _setState(
          password2: val,
          password2Error: Validator.confirmPassword(_state.password, val),
        );
        break;
      case LoginInputType.name:
        _setState(
          fullName: val,
          fullNameError: Validator.emptyField(val),
        );
        break;
      case LoginInputType.matric:
        _setState(
          matricNo: val,
          matricNoError: Validator.emptyField(val),
        );
        break;
      default:
    }

    // Update signup request after validation
    _updateSignupRequest();
  }

  /// ✅ **Updates the signup request in AuthViewModel**
  void _updateSignupRequest() {
    authViewModel.createStudentRequest = CreateStudentRequest(
      email: _state.email,
      gender: _state.gender ?? '',
      password: _state.password,
      departmentId: _state.department,
      dob: _state.dateOfBirth,
      facultyId: _state.faculty,
      image: _state.image,
      levelId: _state.level,
      matricNumber: _state.matricNo,
      name: _state.fullName,
      phone: _state.phoneNumber,
      roleId: int.tryParse(_state.role) ?? 0,
      schoolId: _state.school ?? '',
    );

    if (kDebugMode) {
      log(authViewModel.createStudentRequest.toString());
      log('Role ID being sent: ${int.tryParse(_state.role) ?? 0}');
      log('Raw role value: ${_state.role}');
    }
  }

  /// ✅ **Sets user role data**
  void setRole(String role) {
    _setState(role: role);
    _updateSignupRequest();
  }

  /// ✅ **Sets school information**
  void setSchool(String? schoolId, String? schoolName) {
    _setState(school: schoolId, schoolName: schoolName);
    _updateSignupRequest();
  }

  /// ✅ **Sets faculty information**
  void setFaculty(String? facultyId, String? facultyName) {
    _setState(faculty: facultyId, facultyName: facultyName);
    _updateSignupRequest();
  }

  /// ✅ **Sets department information**
  void setDepartment(String? departmentId, String? departmentName) {
    _setState(department: departmentId, departmentName: departmentName);
    _updateSignupRequest();
  }

  /// ✅ **Sets level information**
  void setLevel(String? levelId, String? levelName) {
    _setState(level: levelId, levelName: levelName);
    _updateSignupRequest();
  }

  /// ✅ **Sets user's gender**
  void setGender(String? gender) {
    _setState(gender: gender);
    _updateSignupRequest();
  }

  /// ✅ **Sets user's date of birth**
  void setDateOfBirth(String dob) {
    _setState(dateOfBirth: dob);
    _updateSignupRequest();
  }

  /// ✅ **Sets profile image**
  void setImage(File? img) {
    _setState(image: img);
    _updateSignupRequest();
  }

  /// ✅ **Handles Signup API Call**
  Future<bool> signUp() async {
    bool success = await authViewModel.signUp();
    return success;
  }

  /// ✅ **Handles Email Verification**
  Future<bool> verifyEmail(String verificationCode) async {
    authViewModel.verifyEmailRequest = VerifyEmailRequest(email: _state.email, verificationCode: verificationCode);
    bool success = await authViewModel.verifyEmail();
    return success;
  }

  /// ✅ **Handles Code Resend Request**
  Future<bool> resendCode() async {
    authViewModel.resendCodeRequest = ResendCodeRequest(
      email: _state.email,
    );
    bool success = await authViewModel.resendCode();
    return success;
  }

  /// ✅ **Clears all validation errors**
  void clearErrors({bool shouldRebuild = true}) {
    _setState(
      emailError: null,
      fullNameError: null,
      phoneNumberError: null,
      passwordError: null,
      password2Error: null,
      matricNoError: null,
    );
  }

  /// ✅ **Clears all form fields**
  void clearFields({bool shouldRebuild = true}) {
    _state = RegistrationState();
    if (shouldRebuild) {
      notifyListeners();
    }
  }
}
