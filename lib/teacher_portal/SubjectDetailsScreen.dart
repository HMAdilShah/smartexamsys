import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';
import 'package:smartexamsys/teacher_portal/StudentListScreen.dart';


class SubjectDetailsScreen extends StatefulWidget {
  @override
  _SubjectDetailsScreenState createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  List<Map<String, dynamic>> subjectData = [];
  List<Map<String, dynamic>> student_subjectData = [];

  @override
  void initState() {
    super.initState();
    fetchSubjectData();
  }

  Future<void> fetchSubjectData() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    QuerySnapshot querySnapshot = await DBHelper().getSubjectInfoByTeacherEmail(email!);

    setState(() {
      subjectData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color(0xFFff800a),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Subject Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjectData.length,
                itemBuilder: (context, index) {
                  return SubjectCard(
                    subject: subjectData[index],
                    onTap: () {
                      //get data for that subject and teacher

                      fetchStudentSubjectData(subjectData[index]["subjectId"]);




                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchStudentSubjectData(String subjId) async {
    String? email = await SaveInSharedPref.getUserEmailPreference();

    QuerySnapshot querySnapshot = await getSubjectInfoByTeacherEmailForResult(email!, subjId);
    student_subjectData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();


    List<Map<String, String>> students = student_subjectData.map((data) {
      return data.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListScreen(
          student_subjectData: students,
        ),
      ),
    );
  }
  Future<QuerySnapshot> getSubjectInfoByTeacherEmailForResult(String teacherEmail, String subjectId) async {
    return FirebaseFirestore.instance
        .collection("student_subjects")
        .where("teacherEmail", isEqualTo: teacherEmail)
        .where("subjectId", isEqualTo: subjectId)
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

}


class SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;

  SubjectCard({required this.subject, required this.onTap});

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
              'Course ID: ${subject['subjectId']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Course Title: ${subject['subjectTitle']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: onTap,
              child: Text(
                'View Student List',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
