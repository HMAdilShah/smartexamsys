


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';
import 'package:smartexamsys/examiner_portal/ViewSeatingPlansScreen.dart';

class NextSeatingPlanScreen extends StatefulWidget {
  final String subjectName;
  final String timing;
  final String date;

  NextSeatingPlanScreen({
    required this.subjectName,
    required this.timing,
    required this.date,
  });

  @override
  _NextSeatingPlanScreenState createState() => _NextSeatingPlanScreenState();
}

class _NextSeatingPlanScreenState extends State<NextSeatingPlanScreen> {
  String noOfRoom = '';
  String noOfStudents = '';
  String studentsInRow = '';
  String studentsInColumn = '';
  String teachersEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              'Create Seating Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 50),
            TextField(
              onChanged: (value) {
                setState(() {
                  teachersEmail = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Teacher Email',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  noOfRoom = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Room Number',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  noOfStudents = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Number of Students',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  studentsInRow = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Students in Each Row',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  studentsInColumn = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Students in Each Column',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _generateSeatingPlan();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Generate', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _generateSeatingPlan() async {
    // Get examiner email
    String? email = await SaveInSharedPref.getUserEmailPreference();

    // Validate inputs (add your validation logic here)
    if (noOfRoom.isEmpty || noOfStudents.isEmpty || studentsInRow.isEmpty || studentsInColumn.isEmpty|| teachersEmail.isEmpty) {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Create a SeatingPlan object
    SeatingPlan seatingPlan = SeatingPlan(
      subjectName: widget.subjectName,
      timing: widget.timing,
      date: widget.date,
      noOfRoom: noOfRoom,
      noOfStudents: noOfStudents,
      studentsInRow: studentsInRow,
      studentsInColumn: studentsInColumn,
      teacherEmail: teachersEmail,
      examinerEmail: email!,
    );

    // Save to Firestore
    FirebaseFirestore.instance.collection('seating_plans').add(seatingPlan.toMap()).then((_) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Seating plan generated and saved successfully.'),
        duration: Duration(seconds: 2),
      ));
    }).then((value) {

      // Navigate to view seating plans screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewSeatingPlansScreen()),
      );
    }).catchError((error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save seating plan.'),
        duration: Duration(seconds: 2),
      ));
    });
  }
}


class SeatingPlan {
  final String subjectName;
  final String timing;
  final String date;
  final String noOfRoom;
  final String noOfStudents;
  final String studentsInRow;
  final String studentsInColumn;
  final String examinerEmail;
  final String teacherEmail;

  SeatingPlan({
    required this.subjectName,
    required this.timing,
    required this.date,
    required this.noOfRoom,
    required this.noOfStudents,
    required this.studentsInRow,
    required this.studentsInColumn,
    required this.examinerEmail,
    required this.teacherEmail,
  });

  factory SeatingPlan.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SeatingPlan(
      subjectName: data['subjectName'],
      timing: data['timing'],
      date: data['date'],
      noOfRoom: data['noOfRoom'],
      noOfStudents: data['noOfStudents'],
      studentsInRow: data['studentsInRow'],
      studentsInColumn: data['studentsInColumn'],
      teacherEmail: data['teacherEmail'],
      examinerEmail: data['examinerEmail'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
      'timing': timing,
      'date': date,
      'noOfRoom': noOfRoom,
      'noOfStudents': noOfStudents,
      'studentsInRow': studentsInRow,
      'studentsInColumn': studentsInColumn,
      'teacherEmail': teacherEmail,
      'examinerEmail': examinerEmail,
    };
  }
}






