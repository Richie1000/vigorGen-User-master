import 'package:cloud_firestore/cloud_firestore.dart';

import 'attendance.dart';

class AttendanceService {
  final CollectionReference _attendanceCollection =
      FirebaseFirestore.instance.collection('attendance');

  Future<void> addAttendance(Attendance attendance) async {
    await _attendanceCollection.add(attendance.toMap());
  }

  Stream<List<Attendance>> getAttendanceStream() {
    return _attendanceCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attendance.fromMap(doc.data(), id: doc.id))
            .toList());
  }
}
