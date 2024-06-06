
import 'package:flutter/material.dart';
import 'package:smartexamsys/examiner_portal/CreateSeatingPlanScreen.dart';
import 'package:smartexamsys/examiner_portal/ViewSeatingPlansScreen.dart';

class SeatingPlanOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Seating Plans',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 80),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewSeatingPlansScreen()),
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
                  'View Seating Plan',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateSeatingPlanScreen()),
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
                  'Add Seating Plan',
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