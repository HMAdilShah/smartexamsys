
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';
import 'package:smartexamsys/database/authentification/Firebase_Authentication.dart';
import 'package:smartexamsys/examiner_portal/ExaminerPortalScreen.dart';
import 'package:smartexamsys/student_portal/StudentPortalScreen.dart';
import 'package:smartexamsys/teacher_portal/TeacherPortalScreen.dart';


class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Firebase_Authentication _firebaseAuthentication = Firebase_Authentication();

  Future<void> applyLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Display an error dialog for incomplete information
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter your email and password.'),
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
      return;
    }

    // Perform the login using Firebase authentication
    try {
      Fluttertoast.showToast(
        msg: "Please wait...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      await _firebaseAuthentication
          .signInWithEmailAndPassword(
          emailController.text, passwordController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
          await DBHelper().getUserByEmail(emailController.text);
          SaveInSharedPref.saveUserLoggedInPreference(true);
          String name = (userInfoSnapshot.docs[0].data()! as Map<String, dynamic>)["name"] as String;
          SaveInSharedPref.saveUserNamePreference(name);
          String email = (userInfoSnapshot.docs[0].data()! as Map<String, dynamic>)["email"] as String;
          SaveInSharedPref.saveUserEmailPreference(email);
          String userRole = (userInfoSnapshot.docs[0].data()! as Map<String, dynamic>)["role"] as String;
          SaveInSharedPref.saveUserGroupPreference(userRole);
          String phone = (userInfoSnapshot.docs[0].data()! as Map<String, dynamic>)["phone"] as String;
          SaveInSharedPref.saveUserPhonePreference(phone);
          // String Email = await SharedPref.getUserEmailSharedPreference();
          // Navigate to the appropriate portal screen based on user role
          Fluttertoast.showToast(
            msg: "Login successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );

          if (userRole == 'student') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentPortalScreen()),
            );
          } else if (userRole == 'teacher') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherPortalScreen()),
            );
          } else if (userRole == 'examiner') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExaminerPortalScreen()),
            );
          }


        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('User not exist or incorrect credentials'),
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
        }
      });






    } catch (e) {
      // Display an error dialog for authentication failure
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Authentication failed. Please check your credentials.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 120,),
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email or Phone',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: () {
                  applyLogin(context); // Call the applyLogin method
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFDB3022),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 50),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentPortalScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Student'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeacherPortalScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Teacher'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExaminerPortalScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Examiner'),
                ),
              ],
            )*/
          ],
        ),
      ),
    );
  }
}


