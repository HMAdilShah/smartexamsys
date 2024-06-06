import 'package:flutter/material.dart';
import 'package:smartexamsys/teacher_portal/SubjectScreen.dart';
import 'package:smartexamsys/teacher_portal/SubmissionOfResultsScreen.dart';
import 'package:smartexamsys/teacher_portal/SurveillanceScreen.dart';

import 'HomeScreen.dart';
import 'ProfileScreen.dart';

class TeacherPortalScreen extends StatefulWidget {
  @override
  _TeacherPortalScreenState createState() => _TeacherPortalScreenState();
}

class _TeacherPortalScreenState extends State<TeacherPortalScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    HomeScreen(),
    SubjectScreen(),
    SurveillanceScreen(),
    SubmissionOfResultsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Teacher Portal', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Subject',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Surveillance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFff800a),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
