import 'package:flutter/material.dart';
import 'package:smartexamsys/teacher_portal/AddSubject.dart';
import 'package:smartexamsys/teacher_portal/SubjectDetailsScreen.dart';

class SubjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select an option',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSubject()),
                  );

                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff800a),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Add Subjects',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubjectDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff800a),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'View Subjects',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
