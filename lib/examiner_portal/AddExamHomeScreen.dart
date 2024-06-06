import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';


import 'package:flutter/material.dart';

class Exam {
  final String subjectId;
  final String subjectTitle;
  final String teacherName;
  final String teacherEmail;
  final String examiner_email;
  final String date;

  Exam({required this.subjectId, required this.subjectTitle, required this.teacherName,
    required this.teacherEmail, required this.examiner_email, required this.date});
}

class AddExamHomeScreen extends StatefulWidget {
  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamHomeScreen> {
  List<Exam> exams = [];

  void _navigateToDetailsEntryScreen() async {
    final newExam = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsEntryScreen(),
      ),
    );

    if (newExam != null) {
      setState(() {
        exams.add(newExam);
      });
    }
  }
  Future<void> _fetchExams() async {
    String? email = await SaveInSharedPref.getUserEmailPreference();

    QuerySnapshot querySnapshot = await getExamByExaminerEmail(email!);
    List<Exam> fetchedExams = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Exam(
        subjectId: doc['subjectId'],
        subjectTitle: data['subjectTitle'],
        teacherName: data['teacherName'],
        teacherEmail: data['teacherEmail'],
        examiner_email: data['examiner_email'],
        date: data['date'],
      );
    }).toList();

    setState(() {
      exams = fetchedExams;
    });
  }

  getExamByExaminerEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("exams")
        .where("examiner_email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    _fetchExams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color(0xFFff800a),
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Duty Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Implement further action
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Course ID: ${exams[index].subjectId}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Course Title: ${exams[index].subjectTitle}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Teacher: ${exams[index].teacherName}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _navigateToDetailsEntryScreen,
              child: Text(
                'Add Exam',
                style: TextStyle(color: Color(0xFFff800a)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsEntryScreen extends StatefulWidget {
  @override
  _DetailsEntryScreenState createState() => _DetailsEntryScreenState();
}

class _DetailsEntryScreenState extends State<DetailsEntryScreen> {
  String courseId = '';
  String courseTitle = '';
  String teacherName = '';
  String teacherEmail = '';
  DateTime selectedDate = DateTime.now(); // Default to current date

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Course ID';
                    }
                    return null;
                  },
                  onSaved: (value) => courseId = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Course Title';
                    }
                    return null;
                  },
                  onSaved: (value) => courseTitle = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Teacher Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Teacher Name';
                    }
                    return null;
                  },
                  onSaved: (value) => teacherName = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Teacher Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Teacher Email';
                    }
                    return null;
                  },
                  onSaved: (value) => teacherEmail = value!,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Date: '+ selectedDate.toString().substring(0,10), style: TextStyle(color: Colors.black),),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveExam,
                  child: Text('Save Exam', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveExam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the user's email
      String? email = await SaveInSharedPref.getUserEmailPreference();

      // Save the exam details to Firebase
      saveExamToFirebase(courseId, courseTitle, teacherName, email!, selectedDate, teacherEmail);

      // Return the new Exam object to the previous screen
      Navigator.pop(
        context,
        Exam(subjectId: courseId, subjectTitle: courseTitle, teacherName: teacherName,
            teacherEmail: teacherEmail, examiner_email: email, date: selectedDate.toString()),
      );
    }
  }

  void saveExamToFirebase(String courseId, String courseTitle, String teacherName,
      String email, DateTime selectedDate, String teacherEmail) {

    FirebaseFirestore.instance.collection("exams").add(
      {
        "subjectId": courseId,
        "subjectTitle": courseTitle,
        "teacherName": teacherName,
        "teacherEmail": teacherEmail,
        "examiner_email": email,
        "date": selectedDate.toString(),
      }
    ).then((value) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exam Added'),
            content: Text('New Exam has been added successfully'),
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
    })
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
}

