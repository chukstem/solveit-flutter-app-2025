import 'dart:convert';

class AuthResponse {
  final int statusCode;
  final String statusMessage;
  final String? token;
  AuthResponse({
    required this.statusCode,
    required this.statusMessage,
    this.token,
  });

  AuthResponse copyWith({
    int? statusCode,
    String? statusMessage,
    String? token,
  }) {
    return AuthResponse(
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'token': token,
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      statusCode: map['statusCode'] as int,
      statusMessage: map['statusMessage'] as String,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) => AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AuthResponse(statusCode: $statusCode, statusMessage: $statusMessage, token: $token)';

  @override
  bool operator ==(covariant AuthResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode && other.statusMessage == statusMessage && other.token == token;
  }

  @override
  int get hashCode => statusCode.hashCode ^ statusMessage.hashCode ^ token.hashCode;
}

class LoginResponse {
  final int status;
  final String message;
  final String? token;
  final UserData userData;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    required this.userData,
  });

  LoginResponse copyWith({
    int? status,
    String? message,
    String? token,
    UserData? userData,
  }) {
    return LoginResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
      userData: userData ?? this.userData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'token': token,
      'userData': userData.toMap(),
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      token: map['token'] != null ? map['token'] as String : null,
      userData: UserData.fromMap(map['userData'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) => LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginResponse(status: $status, message: $message, token: $token, userData: $userData)';

  @override
  bool operator ==(covariant LoginResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && other.token == token && other.userData == userData;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ token.hashCode ^ userData.hashCode;
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String gender;
  final int schoolId;
  final String code;
  final int roleId;
  final String matricNumber;
  final int facultyId;
  final int departmentId;
  final int levelId;
  final String userCategory;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.schoolId,
    required this.code,
    required this.roleId,
    required this.matricNumber,
    required this.facultyId,
    required this.departmentId,
    required this.levelId,
    required this.userCategory,
  });

  UserData copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? gender,
    int? schoolId,
    String? code,
    int? roleId,
    String? matricNumber,
    int? facultyId,
    int? departmentId,
    int? levelId,
    String? userCategory,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      schoolId: schoolId ?? this.schoolId,
      code: code ?? this.code,
      roleId: roleId ?? this.roleId,
      matricNumber: matricNumber ?? this.matricNumber,
      facultyId: facultyId ?? this.facultyId,
      departmentId: departmentId ?? this.departmentId,
      levelId: levelId ?? this.levelId,
      userCategory: userCategory ?? this.userCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'school_id': schoolId,
      'code': code,
      'role_id': roleId,
      'matric_number': matricNumber,
      'faculty_id': facultyId,
      'department_id': departmentId,
      'level_id': levelId,
      'user_category': userCategory,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      schoolId: map['school_id'] ?? 0,
      code: map['code'] ?? '',
      roleId: map['role_id'] ?? 0,
      matricNumber: map['matric_number'] ?? '',
      facultyId: map['faculty_id'] ?? '',
      departmentId: map['department_id'] ?? '',
      levelId: map['level_id'] ?? '',
      userCategory: map['user_category'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, email: $email, phone: $phone, dob: $dob, gender: $gender, schoolId: $schoolId, code: $code, roleId: $roleId, matricNumber: $matricNumber, facultyId: $facultyId, departmentId: $departmentId, levelId: $levelId, userCategory: $userCategory)';
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.dob == dob &&
        other.gender == gender &&
        other.schoolId == schoolId &&
        other.code == code &&
        other.roleId == roleId &&
        other.matricNumber == matricNumber &&
        other.facultyId == facultyId &&
        other.departmentId == departmentId &&
        other.levelId == levelId &&
        other.userCategory == userCategory;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        schoolId.hashCode ^
        code.hashCode ^
        roleId.hashCode ^
        matricNumber.hashCode ^
        facultyId.hashCode ^
        departmentId.hashCode ^
        levelId.hashCode ^
        userCategory.hashCode;
  }
}
