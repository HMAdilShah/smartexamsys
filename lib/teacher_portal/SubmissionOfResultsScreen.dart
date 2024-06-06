

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

class SubmissionOfResultsScreen extends StatefulWidget {
  @override
  _SubmissionOfResultsScreenState createState() =>
      _SubmissionOfResultsScreenState();
}

class _SubmissionOfResultsScreenState
    extends State<SubmissionOfResultsScreen> {
  List<StudentResult> studentResults = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    QuerySnapshot studentSubjectsSnapshot =
    await DBHelper().getSubjectInfoByTeacherEmailForResult(email!);

    List<StudentResult> results = [];
    studentSubjectsSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      results.add(StudentResult(
        doc.id,
        doc['subjectId'],
        doc['subjectTitle'],
        doc['userEmail'],
        doc['sapId'],
        doc['marks'],
        doc['grades'],
      ));
    });

    setState(() {
      studentResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color(0xFFff800a),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              'Submission of Results',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: studentResults.length,
                itemBuilder: (context, index) {
                  return StudentResultCard(studentResults[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


class StudentResult {
  final String doc_id;
  final String courseId;
  final String courseTitle;
  final String studentName;
  final String sapId;
  String marks;
  String grade;

  StudentResult(this.doc_id, this.courseId, this.courseTitle, this.studentName, this.sapId, this.marks, this.grade);
}

class StudentResultCard extends StatefulWidget {
  final StudentResult studentResult;

  StudentResultCard(this.studentResult);

  @override
  _StudentResultCardState createState() => _StudentResultCardState();
}

class _StudentResultCardState extends State<StudentResultCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course ID: ${widget.studentResult.courseId}', style: TextStyle(fontSize: 18)),
            Text('Course Title: ${widget.studentResult.courseTitle}', style: TextStyle(fontSize: 18)),
            Text('Student Name: ${widget.studentResult.studentName}', style: TextStyle(fontSize: 18)),
            Text('SAP ID: ${widget.studentResult.sapId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Marks: ${widget.studentResult.marks}', style: TextStyle(fontSize: 18)),
            Text('Grade: ${widget.studentResult.grade}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            widget.studentResult.grade.isEmpty ? ElevatedButton(
              onPressed: () {
                _navigateToEditScreen(context, widget.studentResult);
              },
              child: Text('Edit Marks and Grades', style: TextStyle(color: Colors.white),),
            ) : Container(),
            Divider(),
          ],
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, StudentResult studentResult) async {
    final updatedResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMarksGradesScreen(studentResult),
      ),
    );

    if (updatedResult != null) {
      setState(() {
        studentResult.marks = updatedResult.marks;
        studentResult.grade = updatedResult.grade;
      });
    }
  }
}

class EditMarksGradesScreen extends StatefulWidget {
  final StudentResult studentResult;

  EditMarksGradesScreen(this.studentResult);

  @override
  _EditMarksGradesScreenState createState() => _EditMarksGradesScreenState();
}

class _EditMarksGradesScreenState extends State<EditMarksGradesScreen> {
  late TextEditingController marksController;
  late TextEditingController gradeController;

  @override
  void initState() {
    super.initState();
    marksController = TextEditingController(text: widget.studentResult.marks);
    gradeController = TextEditingController(text: widget.studentResult.grade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Marks and Grades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: marksController,
              decoration: InputDecoration(labelText: 'Marks'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveAndExit();
              },
              child: Text('Save', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndExit() {
    final updatedResult = StudentResult(
        widget.studentResult.doc_id,
      widget.studentResult.courseId,
      widget.studentResult.courseTitle,
      widget.studentResult.studentName,
      widget.studentResult.sapId,
      marksController.text,
      gradeController.text
    );

    // Update the document in Firestore
    FirebaseFirestore.instance
        .collection("student_subjects")
        .doc(widget.studentResult.doc_id)
        .update({
      'marks': updatedResult.marks,
      'grades': updatedResult.grade,
    })
        .then((_) {
      Navigator.pop(context, updatedResult);
    })
        .catchError((error) {
      print("Error updating document: $error");
      Fluttertoast.showToast(
        msg: "Some error : $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    });

    Navigator.pop(context, updatedResult);
  }
}

