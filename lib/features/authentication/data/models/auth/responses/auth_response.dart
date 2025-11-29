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
    // Backend wraps data in a 'data' object: {status: 200, message: "...", data: {user: {...}, access_token: "..."}}
    final data = map['data'] as Map<String, dynamic>?;
    
    // Extract user data - backend returns it in data.user
    final userMap = data?['user'] as Map<String, dynamic>? ?? map['userData'] as Map<String, dynamic>?;
    if (userMap == null) {
      throw FormatException('User data not found in response');
    }
    
    return LoginResponse(
      status: map['status'] is int ? map['status'] as int : (int.tryParse(map['status']?.toString() ?? '200') ?? 200),
      message: map['message']?.toString() ?? '',
      token: data?['access_token']?.toString() ?? map['token']?.toString(),
      userData: UserData.fromMap(userMap),
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
    // Handle date conversion - backend may return DateTime or string
    String dobString = '';
    if (map['dob'] != null) {
      if (map['dob'] is DateTime) {
        dobString = (map['dob'] as DateTime).toIso8601String();
      } else if (map['dob'] is String) {
        dobString = map['dob'] as String;
      }
    }
    
    return UserData(
      id: map['id'] is int ? map['id'] as int : (int.tryParse(map['id']?.toString() ?? '0') ?? 0),
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      dob: dobString,
      gender: map['gender']?.toString() ?? '',
      schoolId: map['school_id'] is int ? map['school_id'] as int : (int.tryParse(map['school_id']?.toString() ?? '0') ?? 0),
      code: map['code']?.toString() ?? '',
      roleId: map['role_id'] is int ? map['role_id'] as int : (int.tryParse(map['role_id']?.toString() ?? '0') ?? 0),
      matricNumber: map['matric_number']?.toString() ?? '',
      facultyId: map['faculty_id'] is int ? map['faculty_id'] as int : (int.tryParse(map['faculty_id']?.toString() ?? '0') ?? 0),
      departmentId: map['department_id'] is int ? map['department_id'] as int : (int.tryParse(map['department_id']?.toString() ?? '0') ?? 0),
      levelId: map['level_id'] is int ? map['level_id'] as int : (int.tryParse(map['level_id']?.toString() ?? '0') ?? 0),
      userCategory: map['user_category']?.toString() ?? '',
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
