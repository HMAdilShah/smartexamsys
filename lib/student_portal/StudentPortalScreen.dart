import 'package:flutter/material.dart';
import 'package:smartexamsys/student_portal/HomeScreen.dart';
import 'package:smartexamsys/student_portal/MySubjectsScreen.dart';
import 'package:smartexamsys/student_portal/ProfileScreen.dart';
import 'package:smartexamsys/student_portal/ResultsScreen.dart';
import 'package:smartexamsys/student_portal/SeatingPlansScreen.dart';

class StudentPortalScreen extends StatefulWidget {
  @override
  _StudentPortalScreenState createState() => _StudentPortalScreenState();
}

class _StudentPortalScreenState extends State<StudentPortalScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    HomeScreen(),
    MySubjectsScreen(),
    SeatingPlansScreen(),
    ResultsScreen(),
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
        title: Text('Student Portal', style: TextStyle(color: Colors.white),),
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
            icon: Icon(Icons.subject),
            label: 'My Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat),
            label: 'Seating Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Results',
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