import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import '../providers/attendance.dart';
import '../providers/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key key}) : super(key: key);
  static const routeName = "./attendanceScreen";

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _attendanceService = AttendanceService();
  final _dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: StreamBuilder<List<Attendance>>(
        stream: _attendanceService.getAttendanceStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final attendance = snapshot.data;

          return ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final record = attendance[index];

              return ListTile(
                title: Text(record.employeeName),
                subtitle: Text(_dateFormat.format(record.date)),
                trailing: Checkbox(
                  value: record.present,
                  onChanged: null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}