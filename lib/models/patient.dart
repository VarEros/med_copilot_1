import 'dart:core';

class Patient {
  int id;
  String personalId;
  String name;
  String lastname;
  DateTime? birthdate;
  String? email;
  String? phone;
  bool followUp;
  int? userId;

  Patient({
    required this.id,
    required this.personalId,
    required this.name,
    required this.lastname,
    this.birthdate,
    this.email,
    this.phone,
    required this.followUp,
    this.userId
  });
  
  int get calculateAge {
    final today = DateTime.now();
    int age = today.year - birthdate!.year;
    if (today.month < birthdate!.month || (today.month == birthdate!.month && today.day < birthdate!.day)) {
      age--;
    }
    return age;
  }
  
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      personalId: json['personal_id'],
      name: json['name'],
      lastname: json['lastname'],
      birthdate: DateTime.parse(json['birthdate']),
      email: json['email'],
      phone: json['phone'],
      followUp: json['follow_up'],
      userId: json['user_id']
    );
  }

  Map<String, dynamic> toJson(int userId) {
    return {
      'id': id,
      'personal_id': personalId,
      'name': name,
      'lastname': lastname,
      'birthdate': '${birthdate!.toUtc().toIso8601String().split('.').first}Z',
      'email': email,
      'phone': phone,
      'follow_up': followUp,
      'user_id': userId
    };
  }
}