


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';
import 'package:smartexamsys/examiner_portal/NextSeatingPlanScreen.dart';

class ViewSeatingPlansScreen extends StatefulWidget {
  @override
  State<ViewSeatingPlansScreen> createState() => _ViewSeatingPlansScreenState();
}

class _ViewSeatingPlansScreenState extends State<ViewSeatingPlansScreen> {
  List<SeatingPlan> seatingList = [];

  @override
  void initState() {
    _fetchSeatingPlans();
    super.initState();
  }

  getSeatingPlanByExaminerEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("seating_plans")
        .where("examinerEmail", isEqualTo: email)
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

  Future<void> _fetchSeatingPlans() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    QuerySnapshot querySnapshot =
    await getSeatingPlanByExaminerEmail(email!);

    setState(() {
      seatingList = querySnapshot.docs
          .map((doc) => SeatingPlan.fromSnapshot(doc))
          .toList();
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
              'View Seating Plans',
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
        padding: EdgeInsets.all(25),
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
              'Start Time: ${seatingPlan.timing}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Room: ${seatingPlan.noOfRoom}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'No. of Row/Col: ${seatingPlan.studentsInRow}/${seatingPlan.studentsInColumn}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


