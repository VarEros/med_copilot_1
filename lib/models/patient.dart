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

  Patient({
    required this.id,
    required this.personalId,
    required this.name,
    required this.lastname,
    this.birthdate,
    this.email,
    this.phone,
    required this.followUp,
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
      followUp: json['follow_up']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personal_id': personalId,
      'name': name,
      'lastname': lastname,
      'birthdate': '${birthdate!.toUtc().toIso8601String().split('.').first}Z',
      'email': email,
      'phone': phone,
      'follow_up': followUp
    };
  }
}