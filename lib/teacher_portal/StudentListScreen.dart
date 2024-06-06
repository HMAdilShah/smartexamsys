import 'package:flutter/material.dart';

class StudentListScreen extends StatelessWidget {
  final List<Map<String, String>> student_subjectData;

  StudentListScreen({required this.student_subjectData});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> students = List.from(student_subjectData);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color(0xFFff800a),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              'Student List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return StudentCard(student: students[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class StudentCard extends StatelessWidget {
  final Map<String, String> student;

  StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SAP ID: ${student['sapId']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'ClassName: ${student['className']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'SubjectTitle: ${student['subjectTitle']}',
              style: TextStyle(fontSize: 16),
            ),


          ],
        ),
      ),
    );
  }
}
