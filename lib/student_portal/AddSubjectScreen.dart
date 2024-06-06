import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart'; // Import the Cloud Firestore package

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final TextEditingController subjectIdController = TextEditingController();
  final TextEditingController subjectTitleController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController teacherEmailController = TextEditingController();
  final TextEditingController sapIdController = TextEditingController();

  String userEmail = '';

  @override
  void initState() {
    super.initState();
    getEmailFromSharedPrefs();
  }

  void getEmailFromSharedPrefs() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    setState(() {
      userEmail = email!;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              'Subject Detail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 30),
            TextField(
              controller: subjectIdController,
              decoration: InputDecoration(
                labelText: 'Enter Subject ID',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: subjectTitleController,
              decoration: InputDecoration(
                labelText: 'Enter Subject Title',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: classNameController,
              decoration: InputDecoration(
                labelText: 'Enter Class Name',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: teacherNameController,
              decoration: InputDecoration(
                labelText: 'Enter Subject Teacher Name',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: teacherEmailController,
              decoration: InputDecoration(
                labelText: 'Enter Teacher Email',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: sapIdController,
              decoration: InputDecoration(
                labelText: 'Enter Sap Id',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: () {
                  validateAndSaveSubject();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFDB3022),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateAndSaveSubject() {
    String subjectId = subjectIdController.text;
    String subjectTitle = subjectTitleController.text;
    String className = classNameController.text;
    String teacherName = teacherNameController.text;
    String teacherEmail = teacherEmailController.text;
    String sapId = sapIdController.text;

    if (subjectId.isEmpty || subjectTitle.isEmpty || teacherName.isEmpty || className.isEmpty
        || teacherEmail.isEmpty || sapId.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete Information'),
            content: Text('Please fill in all the fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Map<String, String> subjectInfoMap = {
        "subjectId": subjectId,
        "subjectTitle": subjectTitle,
        "teacherName": teacherName,
        "className": className,
        "userEmail": userEmail,
        "teacherEmail": teacherEmail,
        "marks": "",
        "grades": "",
        "sapId": sapId,
        // Add more fields if needed
      };

      DBHelper().saveSubjectInfo(subjectInfoMap);
      Navigator.pop(context);
      // Optionally, you can show a success message or navigate back to the previous screen
    }
  }
}
