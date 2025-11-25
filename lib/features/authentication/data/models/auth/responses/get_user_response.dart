// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentOrUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? interests;
  final DateTime dob;
  final String gender;
  final int schoolId;
  final String balance;
  final String affiliateBalance;
  final String? bankInformation;
  final dynamic permissions;
  final dynamic emailVerified;
  final int phoneVerified;
  final String? faceId;
  final int faceVerified;
  final String? idVerification;
  final int idVerified;
  final int? userId;
  final int? staffId;
  final int? studentId;
  final int? lecturerId;
  final String? lastLogin;
  final String? sendNextOtpSmsAfter;
  final int coreServiceEarningTimes;
  final String? passwordResetCode;
  final String online;
  final String type;
  final String code;
  final String password;
  final String? dfsdasdeder;
  final String? rememberToken;
  final String? deletedAt;
  final DateTime createdAt;
  final String? updatedAt;
  final int roleId;
  StudentOrUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.interests,
    required this.dob,
    required this.gender,
    required this.schoolId,
    required this.balance,
    required this.affiliateBalance,
    this.bankInformation,
    required this.permissions,
    required this.emailVerified,
    required this.phoneVerified,
    this.faceId,
    required this.faceVerified,
    this.idVerification,
    required this.idVerified,
    this.userId,
    this.staffId,
    this.studentId,
    this.lecturerId,
    this.lastLogin,
    this.sendNextOtpSmsAfter,
    required this.coreServiceEarningTimes,
    this.passwordResetCode,
    required this.online,
    required this.type,
    required this.code,
    required this.password,
    this.dfsdasdeder,
    this.rememberToken,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
    required this.roleId,
  });

  factory StudentOrUserModel.fromMap(Map<String, dynamic> json) {
    return StudentOrUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      interests: json['interests'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      schoolId: json['school_id'],
      balance: json['balance'],
      affiliateBalance: json['affiliate_balance'],
      bankInformation: json['bank_information'],
      permissions: json['permissions'],
      emailVerified: json['email_verified'],
      phoneVerified: json['phone_verified'],
      faceId: json['face_id'],
      faceVerified: json['face_verified'],
      idVerification: json['id_verification'],
      idVerified: json['id_verified'],
      userId: json['user_id'],
      staffId: json['staff_id'],
      studentId: json['student_id'],
      lecturerId: json['lecturer_id'],
      lastLogin: json['last_login'],
      sendNextOtpSmsAfter: json['send_next_otp_sms_after'],
      coreServiceEarningTimes: json['core_service_earning_times'],
      passwordResetCode: json['password_reset_code'],
      online: json['online'],
      type: json['type'],
      code: json['code'],
      password: json['password'],
      dfsdasdeder: json['dfsdasdeder'],
      rememberToken: json['remember_token'],
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'],
      roleId: json['role_id'],
    );
  }

  StudentOrUserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? interests,
    DateTime? dob,
    String? gender,
    int? schoolId,
    String? balance,
    String? affiliateBalance,
    String? bankInformation,
    dynamic permissions,
    dynamic emailVerified,
    int? phoneVerified,
    String? faceId,
    int? faceVerified,
    String? idVerification,
    int? idVerified,
    int? userId,
    int? staffId,
    int? studentId,
    int? lecturerId,
    String? lastLogin,
    String? sendNextOtpSmsAfter,
    int? coreServiceEarningTimes,
    String? passwordResetCode,
    String? online,
    String? type,
    String? code,
    String? password,
    String? dfsdasdeder,
    String? rememberToken,
    String? deletedAt,
    DateTime? createdAt,
    String? updatedAt,
    int? roleId,
  }) {
    return StudentOrUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      interests: interests ?? this.interests,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      schoolId: schoolId ?? this.schoolId,
      balance: balance ?? this.balance,
      affiliateBalance: affiliateBalance ?? this.affiliateBalance,
      bankInformation: bankInformation ?? this.bankInformation,
      permissions: permissions ?? this.permissions,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      faceId: faceId ?? this.faceId,
      faceVerified: faceVerified ?? this.faceVerified,
      idVerification: idVerification ?? this.idVerification,
      idVerified: idVerified ?? this.idVerified,
      userId: userId ?? this.userId,
      staffId: staffId ?? this.staffId,
      studentId: studentId ?? this.studentId,
      lecturerId: lecturerId ?? this.lecturerId,
      lastLogin: lastLogin ?? this.lastLogin,
      sendNextOtpSmsAfter: sendNextOtpSmsAfter ?? this.sendNextOtpSmsAfter,
      coreServiceEarningTimes: coreServiceEarningTimes ?? this.coreServiceEarningTimes,
      passwordResetCode: passwordResetCode ?? this.passwordResetCode,
      online: online ?? this.online,
      type: type ?? this.type,
      code: code ?? this.code,
      password: password ?? this.password,
      dfsdasdeder: dfsdasdeder ?? this.dfsdasdeder,
      rememberToken: rememberToken ?? this.rememberToken,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roleId: roleId ?? this.roleId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "avatar": avatar,
      "interests": interests,
      "dob": dob.toIso8601String(),
      "gender": gender,
      "school_id": schoolId,
      "balance": balance,
      "affiliate_balance": affiliateBalance,
      "bank_information": bankInformation,
      "permissions": permissions,
      "email_verified": emailVerified,
      "phone_verified": phoneVerified,
      "face_id": faceId,
      "face_verified": faceVerified,
      "id_verification": idVerification,
      "id_verified": idVerified,
      "user_id": userId,
      "staff_id": staffId,
      "student_id": studentId,
      "lecturer_id": lecturerId,
      "last_login": lastLogin,
      "send_next_otp_sms_after": sendNextOtpSmsAfter,
      "core_service_earning_times": coreServiceEarningTimes,
      "password_reset_code": passwordResetCode,
      "online": online,
      "type": type,
      "code": code,
      "password": password,
      "dfsdasdeder": dfsdasdeder,
      "remember_token": rememberToken,
      "deleted_at": deletedAt,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt,
      "role_id": roleId,
    };
  }

  String toJson() => json.encode(toMap());

  factory StudentOrUserModel.fromJson(String source) => StudentOrUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentOrUserModel(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, interests: $interests, dob: $dob, gender: $gender, schoolId: $schoolId, balance: $balance, affiliateBalance: $affiliateBalance, bankInformation: $bankInformation, permissions: $permissions, emailVerified: $emailVerified, phoneVerified: $phoneVerified, faceId: $faceId, faceVerified: $faceVerified, idVerification: $idVerification, idVerified: $idVerified, userId: $userId, staffId: $staffId, studentId: $studentId, lecturerId: $lecturerId, lastLogin: $lastLogin, sendNextOtpSmsAfter: $sendNextOtpSmsAfter, coreServiceEarningTimes: $coreServiceEarningTimes, passwordResetCode: $passwordResetCode, online: $online, type: $type, code: $code, password: $password, dfsdasdeder: $dfsdasdeder, rememberToken: $rememberToken, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, roleId: $roleId)';
  }

  @override
  bool operator ==(covariant StudentOrUserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.interests == interests &&
        other.dob == dob &&
        other.gender == gender &&
        other.schoolId == schoolId &&
        other.balance == balance &&
        other.affiliateBalance == affiliateBalance &&
        other.bankInformation == bankInformation &&
        other.permissions == permissions &&
        other.emailVerified == emailVerified &&
        other.phoneVerified == phoneVerified &&
        other.faceId == faceId &&
        other.faceVerified == faceVerified &&
        other.idVerification == idVerification &&
        other.idVerified == idVerified &&
        other.userId == userId &&
        other.staffId == staffId &&
        other.studentId == studentId &&
        other.lecturerId == lecturerId &&
        other.lastLogin == lastLogin &&
        other.sendNextOtpSmsAfter == sendNextOtpSmsAfter &&
        other.coreServiceEarningTimes == coreServiceEarningTimes &&
        other.passwordResetCode == passwordResetCode &&
        other.online == online &&
        other.type == type &&
        other.code == code &&
        other.password == password &&
        other.dfsdasdeder == dfsdasdeder &&
        other.rememberToken == rememberToken &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.roleId == roleId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        avatar.hashCode ^
        interests.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        schoolId.hashCode ^
        balance.hashCode ^
        affiliateBalance.hashCode ^
        bankInformation.hashCode ^
        permissions.hashCode ^
        emailVerified.hashCode ^
        phoneVerified.hashCode ^
        faceId.hashCode ^
        faceVerified.hashCode ^
        idVerification.hashCode ^
        idVerified.hashCode ^
        userId.hashCode ^
        staffId.hashCode ^
        studentId.hashCode ^
        lecturerId.hashCode ^
        lastLogin.hashCode ^
        sendNextOtpSmsAfter.hashCode ^
        coreServiceEarningTimes.hashCode ^
        passwordResetCode.hashCode ^
        online.hashCode ^
        type.hashCode ^
        code.hashCode ^
        password.hashCode ^
        dfsdasdeder.hashCode ^
        rememberToken.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        roleId.hashCode;
  }
}
