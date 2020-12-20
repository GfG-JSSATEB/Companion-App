import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Student {
  final String id;
  final String email;
  final String name;
  final String usn;
  final String college;
  final String branch;
  final String year;
  final bool isAdmin;
  final List<String> participated;
  final List<String> won;

  Student({
    @required this.participated,
    @required this.won,
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.usn,
    @required this.college,
    @required this.branch,
    @required this.year,
    @required this.isAdmin,
  });

  factory Student.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data();

    return Student(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      usn: data['usn'] as String,
      college: data['college'] as String,
      branch: data['branch'] as String,
      year: data['year'] as String,
      isAdmin: data['isAdmin'] as bool,
      participated: data['participated'] as List<String>,
      won: data['won'] as List<String>,
    );
  }
}
