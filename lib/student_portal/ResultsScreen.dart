import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

class ResultsScreen extends StatefulWidget {
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, String>> subjectsData = [];

  @override
  void initState() {
    fetchSubjectsData();
    super.initState();
  }

  void fetchSubjectsData() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    QuerySnapshot subjectSnapshot = await DBHelper().getSubjectInfoByEmail(email!);

    List<Map<String, String>> subjects = [];
    for (var doc in subjectSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      subjects.add({
        'className': data['className'],
        'grades': data['grades'],
        'marks': data['marks'],
        'sapId': data['sapId'],
        'subjectId': data['subjectId'],
        'subjectTitle': data['subjectTitle'],
        'teacherEmail': data['teacherEmail'],
        'teacherName': data['teacherName'],
        'userEmail': data['userEmail'],
      });
    }

    setState(() {
      subjectsData = subjects;
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
              'Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjectsData.length,
                itemBuilder: (context, index) {
                  return ResultCard(result: subjectsData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final Map<String, String> result;

  ResultCard({required this.result});

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
              'Course ID: ${result['subjectId']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Course Title: ${result['subjectTitle']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Grade: ${result['grades']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Marks: ${result['marks']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Teacher: ${result['teacherName']}',
              style: TextStyle(fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }
}
