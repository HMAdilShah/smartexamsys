import 'package:flutter/material.dart';
import 'package:smartexamsys/examiner_portal/AddExamHomeScreen.dart';
import 'package:smartexamsys/examiner_portal/HomeScreen.dart';
import 'package:smartexamsys/examiner_portal/SeatingPlanOptionsScreen.dart';
import 'package:smartexamsys/teacher_portal/ProfileScreen.dart';

class ExaminerPortalScreen extends StatefulWidget {
  @override
  _ExaminerPortalScreenState createState() => _ExaminerPortalScreenState();
}

class _ExaminerPortalScreenState extends State<ExaminerPortalScreen> {
  int _selectedIndex = 0;

   List<Widget> _widgetOptions = <Widget>[
     HomeScreen(),
    AddExamHomeScreen(),
    SeatingPlanOptionsScreen(),
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
        title: Text('Examiner Portal'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Seating Plan',
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

