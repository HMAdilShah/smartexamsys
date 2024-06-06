import 'package:flutter/material.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';
import 'package:smartexamsys/student_portal/AddSubjectScreen.dart';
import 'package:smartexamsys/student_portal/MySubjects.dart';

class MySubjectsScreen extends StatelessWidget {
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
              width: MediaQuery.of(context).size.width/1.2,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSubjectScreen()),
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
                  'Add Subject',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width/1.2,
              child: ElevatedButton(
                onPressed: () async {
                  String? email = await SaveInSharedPref.getUserEmailPreference();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewSubjectsScreen(userEmail: email,)),
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