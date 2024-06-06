import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/DBHelper.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

import 'SignInScreen.dart';
import 'database/authentification/Firebase_Authentication.dart';



import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String selectedRole = ''; // Holds the selected role from the dropdown

  Firebase_Authentication _firebaseAuthentication = Firebase_Authentication();
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80,),
            Text(
              'Register Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nameTextEditingController,
              decoration: InputDecoration(
                labelText: 'Name',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: emailTextEditingController,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: phoneNumberTextEditingController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordTextEditingController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value!; // Update the selected role
                });
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('Select a Role'), // Placeholder option
                ),
                DropdownMenuItem(
                  value: 'student',
                  child: Text('Student'),
                ),
                DropdownMenuItem(
                  value: 'teacher',
                  child: Text('Teacher'),
                ),
                DropdownMenuItem(
                  value: 'examiner',
                  child: Text('Examiner'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Role',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _registerUser();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFDB3022),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Registration complete'),
                      content: Text('Congratulations! your registration is done successfully.'),
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


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(text: 'Already a user? '),
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(color: Color(0xFF25E4FE)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    String name = nameTextEditingController.text;
    String email = emailTextEditingController.text;
    String phoneNumber = phoneNumberTextEditingController.text;
    String password = passwordTextEditingController.text;

    if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || selectedRole.isEmpty) {
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
      Map<String, String> userInfoMap = {
        "name": name,
        "email": email,
        "phone": phoneNumber,
        "role": selectedRole,
        // Add more fields if needed
      };

      _firebaseAuthentication.signUpWithEmailAndPassword(email, password).then((val) {
        _dbHelper.saveUserInfo(userInfoMap);
        // SaveInSharedPref.saveUserLoggedInPreference(true);

        Fluttertoast.showToast(
          msg: "Registration successful, Please login here!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      });
    }
  }
}
