import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';




class ViewSubjectsScreen extends StatefulWidget {
  final String? userEmail;

  ViewSubjectsScreen({this.userEmail});

  @override
  _ViewSubjectsScreenState createState() => _ViewSubjectsScreenState();
}

class _ViewSubjectsScreenState extends State<ViewSubjectsScreen> {
  List<Map<String, String>> subjectsData = [];

  @override
  void initState() {
    super.initState();
    fetchSubjectsData();
  }

  void fetchSubjectsData() async {
    QuerySnapshot subjectSnapshot = await getSubjectInfoByEmail(widget.userEmail!);

    List<Map<String, String>> subjects = [];
    for (var doc in subjectSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      subjects.add({
        'courseId': data['subjectId'],
        'courseTitle': data['subjectTitle'],
        'className': data['className'],
        'teacherName': data['teacherName'],
      });
    }

    setState(() {
      subjectsData = subjects;
    });
  }

  Future<QuerySnapshot> getSubjectInfoByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("student_subjects")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: "Some error : $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    });
  }

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
              'Registered Subjects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjectsData.length,
                itemBuilder: (context, index) {
                  return SubjectCard(subject: subjectsData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Map<String, String> subject;

  SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course ID: ${subject['courseId']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Course Title: ${subject['courseTitle']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Class Name: ${subject['className']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Teacher Name: ${subject['teacherName']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
