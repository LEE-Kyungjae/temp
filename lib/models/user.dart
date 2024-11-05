import 'dart:convert';

class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;
  final DateTime dateOfBirth;
  final Gender gender;
  final String address;
  final String zipCode;  // 우편번호 필드 추가
  final Map<String, dynamic> socialMediaAccounts;
  final DateTime registrationDate;
  final DateTime lastLogin;
  final Map<String, dynamic> settings;
  final Set<Role> roles;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.zipCode,  // 우편번호 필드 추가
    required this.socialMediaAccounts,
    required this.registrationDate,
    required this.lastLogin,
    required this.settings,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePictureUrl: json['profilePictureUrl'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: Gender.values.firstWhere((e) => e.toString() == 'Gender.${json['gender']}'),
      address: json['address'],
      zipCode: json['zipCode'],  // 우편번호 필드 추가
      socialMediaAccounts: jsonDecode(json['socialMediaAccounts']),
      registrationDate: DateTime.parse(json['registrationDate']),
      lastLogin: DateTime.parse(json['lastLogin']),
      settings: jsonDecode(json['settings']),
      roles: (json['roles'] as List).map((e) => Role.fromJson(e)).toSet(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender.toString().split('.').last,
      'address': address,
      'zipCode': zipCode,  // 우편번호 필드 추가
      'socialMediaAccounts': jsonEncode(socialMediaAccounts),
      'registrationDate': registrationDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'settings': jsonEncode(settings),
      'roles': roles.map((e) => e.toJson()).toList(),
    };
  }
}

enum Gender {
  MALE, FEMALE, OTHER
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
