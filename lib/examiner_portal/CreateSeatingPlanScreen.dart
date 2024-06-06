import 'package:flutter/material.dart';
import 'package:smartexamsys/examiner_portal/NextSeatingPlanScreen.dart';

class CreateSeatingPlanScreen extends StatefulWidget {
  @override
  _CreateSeatingPlanScreenState createState() => _CreateSeatingPlanScreenState();
}

class _CreateSeatingPlanScreenState extends State<CreateSeatingPlanScreen> {
  String subjectName = '';
  String timing = '';
  String date = '';

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
                  subjectName = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Subject Name',
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
                  timing = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Timing',
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
                  date = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Date',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextSeatingPlanScreen(
                          subjectName: subjectName,
                          timing: timing,
                          date: date,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Next', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
