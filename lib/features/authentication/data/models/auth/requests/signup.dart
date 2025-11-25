// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:solveit/utils/utils/string_utils.dart';

class SignupRequest {
  final String role;
  final String school;
  final String? faculty;
  final String? department;
  final String? level;
  final String fullName;
  final String email;
  final String phoneNo;
  final String gender;
  final String dateOfBirth;
  final String password;

  SignupRequest({
    required this.role,
    required this.school,
    required this.faculty,
    required this.department,
    required this.level,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.gender,
    required this.dateOfBirth,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "role_id": int.parse(role),
      "school_id": int.parse(school),
      if (faculty != null && faculty!.isNotEmpty) "faculty_id": int.parse(faculty!),
      if (department != null && department!.isNotEmpty) "department_id": int.parse(department!),
      if (level != null && level!.isNotEmpty) "level_id": int.parse((level == '600' || level == 'Graduate') ? '500' : level!),
      "name": fullName,
      "email": email.trim().toLowerCase(),
      "phone": StringUtils.formatPhoneNumberForApi(phoneNo),
      "gender": gender.toLowerCase(),
      "dob": dateOfBirth,
      "password": password,
      "password_confirmation": password, // Backend requires password confirmation
    };
  }

  SignupRequest copyWith({
    String? role,
    String? school,
    String? faculty,
    String? department,
    String? level,
    String? fullName,
    String? email,
    String? phoneNo,
    String? gender,
    String? dateOfBirth,
    String? password,
  }) {
    return SignupRequest(
      role: role ?? this.role,
      school: school ?? this.school,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      level: level ?? this.level,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'SignupRequest(role: $role, school: $school, faculty: $faculty, department: $department, level: $level, fullName: $fullName, email: $email, phoneNo: $phoneNo, gender: $gender, dateOfBirth: $dateOfBirth, password: $password)';
  }
}

class CreateStudentRequest {
  final int roleId;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String gender;
  final String schoolId;
  final String? interests;
  final String? facultyId;
  final String? departmentId;
  final String? levelId;
  final String password;
  final String? matricNumber;
  final File? image;

  CreateStudentRequest({
    required this.roleId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.schoolId,
    this.interests,
    this.facultyId,
    this.departmentId,
    this.levelId,
    required this.password,
    this.matricNumber,
    this.image,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'role_id': roleId,
      'name': name,
      "email": email.trim().toLowerCase(),
      "phone": StringUtils.formatPhoneNumberForApi(phone),
      "gender": gender.toLowerCase(),
      'dob': dob,
      'school_id': schoolId,
      if (interests != null) 'interests': interests,
      if (facultyId != null) 'faculty_id': facultyId,
      if (departmentId != null) 'department_id': departmentId,
      if (levelId != null) 'level_id': levelId,
      'password': password,
      if (matricNumber != null) 'matric_number': matricNumber,
      if (image != null)
        'image': MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }

  @override
  String toString() {
    return 'CreateStudentRequest(roleId: $roleId, name: $name, email: $email, phone: $phone, dob: $dob, gender: $gender, schoolId: $schoolId, interests: $interests, facultyId: $facultyId, departmentId: $departmentId, levelId: $levelId, password: $password, matricNumber: $matricNumber, image: $image)';
  }
}
