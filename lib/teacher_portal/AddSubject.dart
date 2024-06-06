import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

class AddSubject extends StatefulWidget {
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final TextEditingController subjectIdController = TextEditingController();
  final TextEditingController subjectTitleController = TextEditingController();

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
            SizedBox(height: 80),
            Text(
              'Subject Detail',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 50),
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
            SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: () {
                  _saveSubject();
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

  void _saveSubject() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();
    String subjectId = subjectIdController.text;
    String subjectTitle = subjectTitleController.text;

    // Validate input if needed

    if (subjectId.isNotEmpty && subjectTitle.isNotEmpty) {
      Map<String, dynamic> subjectInfoMap = {
        "email": email,
        "subjectId": subjectId,
        "subjectTitle": subjectTitle,
        // Add more fields if needed
      };

      saveSubjectInfo(subjectInfoMap);
    }
  }

  void saveSubjectInfo(Map<String, dynamic> subjectInfoMap) {
    FirebaseFirestore.instance
        .collection("subjects")
        .add(subjectInfoMap)
        .then((_) {
      Fluttertoast.showToast(
        msg: "Added successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      // Successfully added subject
      Navigator.pop(context); // Navigate back
    })
        .catchError((e) {
      print("Error saving subject: $e");
      Fluttertoast.showToast(
        msg: "Some error : $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      // Handle error if needed
    });
  }
}
