import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String id;
  String employeeName;
  DateTime date;
  bool present;

  Attendance({
    this.id,
    this.employeeName,
    this.date,
    this.present,
  });

  Attendance.fromMap(Map<String, dynamic> map, {String id})
      : id = id,
        employeeName = map['employeeName'],
        date = (map['date'] as Timestamp).toDate(),
        present = map['present'];

  Map<String, dynamic> toMap() {
    return {
      'employeeName': employeeName,
      'date': date,
      'present': present,
    };
  }
}
