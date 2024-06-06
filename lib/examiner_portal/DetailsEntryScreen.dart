// import 'package:flutter/material.dart';
// import 'package:smartexamsys/examiner_portal/AddExamHomeScreen.dart';
//
// class DetailsEntryScreen extends StatefulWidget {
//   @override
//   _DetailsEntryScreenState createState() => _DetailsEntryScreenState();
// }
//
// class _DetailsEntryScreenState extends State<DetailsEntryScreen> {
//   TextEditingController courseIdController = TextEditingController();
//   TextEditingController courseTitleController = TextEditingController();
//   TextEditingController teacherNameController = TextEditingController();
//
//   void _addExamDetails() {
//     final newExam = Exam(
//       subjectId: courseIdController.text,
//       subjectTitle: courseTitleController.text,
//       teacherName: teacherNameController.text,
//
//     );
//
//     Navigator.pop(context, newExam);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text('Add Exam Details'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: courseIdController,
//               decoration: InputDecoration(labelText: 'Course ID'),
//             ),
//             TextField(
//               controller: courseTitleController,
//               decoration: InputDecoration(labelText: 'Course Title'),
//             ),
//             TextField(
//               controller: teacherNameController,
//               decoration: InputDecoration(labelText: 'Teacher Name'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _addExamDetails,
//               child: Text('Add Exam', style: TextStyle(color: Colors.white),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
