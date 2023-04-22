import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/attendance.dart';
import '../providers/attendance_service.dart';

class AddAttendancePage extends StatefulWidget {
  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
  static const routeName = '/add_attendance_screen';
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  
  final _formKey = GlobalKey<FormState>();
  final _attendanceService = AttendanceService();
  final _dateFormat = DateFormat.yMMMMd();
  final _employeeNameController = TextEditingController();
  bool _present = false;

  @override
  void dispose() {
    _employeeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _employeeNameController,
                decoration: InputDecoration(
                  labelText: 'Employee Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the employee name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Present'),
                  Checkbox(
                    value: _present,
                    onChanged: (value) {
                      setState(() {
                        _present = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final attendance = Attendance(
                      employeeName: _employeeNameController.text,
                      date: DateTime.now(),
                      present: _present,
                    );
                    await _attendanceService.addAttendance(attendance);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
