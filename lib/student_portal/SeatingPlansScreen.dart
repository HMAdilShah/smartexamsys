import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatingPlan {
  final String teacherEmail;
  final String subjectName;
  final String date;
  final String startTime;
  final String noOfRoom;
  final String studentsInRow;
  final String studentsInColumn;

  SeatingPlan({
    required this.teacherEmail,
    required this.subjectName,
    required this.date,
    required this.startTime,
    required this.noOfRoom,
    required this.studentsInRow,
    required this.studentsInColumn,
  });

  SeatingPlan.fromSnapshot(DocumentSnapshot snapshot)
      : teacherEmail = snapshot['teacherEmail'],
        subjectName = snapshot['subjectName'],
        date = snapshot['date'],
        startTime = snapshot['timing'],
        noOfRoom = snapshot['noOfRoom'],
        studentsInRow = snapshot['studentsInRow'],
        studentsInColumn = snapshot['studentsInColumn'];
}

class SeatingPlansScreen extends StatefulWidget {
  @override
  State<SeatingPlansScreen> createState() => _SeatingPlansScreenState();
}

class _SeatingPlansScreenState extends State<SeatingPlansScreen> {
  List<Map<String, String>> subjectsData = [];
  List<SeatingPlan> seatingList = [];

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
        'courseId': data['subjectId'],
        'courseTitle': data['subjectTitle'],
        'className': data['className'],
        'teacherName': data['teacherName'],
        'teacherEmail': data['teacherEmail'],
      });
    }

    subjectsData = subjects;
    _fetchSeatingPlans(email);
  }

  Future<void> _fetchSeatingPlans(String teacherEmail) async {
    QuerySnapshot querySnapshot = await getSeatingPlan();

    List<SeatingPlan> matchingSeatingPlans = [];
    for (var doc in querySnapshot.docs) {
      SeatingPlan seatingPlan = SeatingPlan.fromSnapshot(doc);
      for (var subject in subjectsData) {
        if (seatingPlan.teacherEmail == subject['teacherEmail'] && seatingPlan.subjectName == subject['courseTitle']) {
          matchingSeatingPlans.add(seatingPlan);
          break;
        }
      }
    }
    setState(() {
      seatingList = matchingSeatingPlans;
    });
  }

  Future<QuerySnapshot> getSeatingPlan() async {
    return FirebaseFirestore.instance
        .collection("seating_plans")
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
            SizedBox(height: 20),
            Text(
              'Seating Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: seatingList.length,
                itemBuilder: (context, index) {
                  return SeatingPlanCard(seatingPlan: seatingList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeatingPlanCard extends StatelessWidget {
  final SeatingPlan seatingPlan;

  SeatingPlanCard({required this.seatingPlan});

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
              'Course Title: ${seatingPlan.subjectName}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${seatingPlan.date}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Start Time: ${seatingPlan.startTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Room: ${seatingPlan.noOfRoom}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Row/Column: ${seatingPlan.studentsInRow}/${seatingPlan.studentsInColumn}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
