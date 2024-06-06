
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart'; // Import Firestore

class SeatingPlan {
  final String roomNo;
  final String startTime;
  final String date;
  final String subjectName;

  SeatingPlan({required this.roomNo, required this.startTime, required this.date, required this.subjectName});

  // Add a factory constructor to create a SeatingPlan from a DocumentSnapshot
  factory SeatingPlan.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SeatingPlan(
      roomNo: data['noOfRoom'],
      startTime: data['timing' ],
      date: data['date'],
      subjectName: data['subjectName'],
    );
  }
}

class DutyInfoScreen extends StatefulWidget {
  @override
  _DutyInfoScreenState createState() => _DutyInfoScreenState();
}

class _DutyInfoScreenState extends State<DutyInfoScreen> {
  List<SeatingPlan> seatingList = [];

  @override
  void initState() {
    _fetchSeatingPlans(); // Fetch seating plans when the screen is initialized
    super.initState();
  }

  Future<void> _fetchSeatingPlans() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    QuerySnapshot querySnapshot =
    await getSeatingPlanByTeacherEmail(email!);

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
        padding: EdgeInsets.all(20),
        color: Color(0xFFff800a),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              'Duty Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: seatingList.length,
                itemBuilder: (context, index) {
                  SeatingPlan seatingPlan = seatingList[index];
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
                          SizedBox(height: 10),
                          Text(
                            'Subject : ${seatingPlan.subjectName}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Room: ${seatingPlan.roomNo}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Start Time: ${seatingPlan.startTime}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Date: ${seatingPlan.date}',
                            style: TextStyle(fontSize: 18),
                          ),

                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Method to fetch seating plans by teacher email
Future<QuerySnapshot> getSeatingPlanByTeacherEmail(String email) async {
  return FirebaseFirestore.instance
      .collection("seating_plans")
      .where("teacherEmail", isEqualTo: email)
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
