import 'package:flutter/material.dart';
import 'package:smartexamsys/teacher_portal/DutyInfoScreen.dart';
import 'package:smartexamsys/teacher_portal/SubjectDetailsScreen.dart';
import 'package:smartexamsys/teacher_portal/SubmissionOfResultsScreen.dart';
import 'package:smartexamsys/teacher_portal/SurveillanceScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              'Smart Examination System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 80),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectDetailsScreen(),
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'My Subjects',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DutyInfoScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Duty Information',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmissionOfResultsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Submission of Result',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurveillanceScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Surveillance Exam',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

