import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  String email = "";

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<QuerySnapshot> getProfileInfoByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("teacherprofile")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  void loadProfileData() async {

    email = (await SaveInSharedPref.getUserEmailPreference())!;
    QuerySnapshot profileSnapshot = await getProfileInfoByEmail(email);

    if (profileSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = profileSnapshot.docs[0].data() as Map<String, dynamic>;

      nameController.text = userData['name'] ?? '';
      departmentController.text = userData['department'] ?? '';

      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'My Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: departmentController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Department',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save profile data to Firestore
                    saveProfileInfo(nameController.text, departmentController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveProfileInfo(String name, String department) async {
    String? email = await SaveInSharedPref.getUserEmailPreference();

    Map<String, dynamic> profileMap = {
      "name": name,
      "department": department,
      "email": email,
    };

    FirebaseFirestore.instance.collection("teacherprofile").add(profileMap)
        .then((value) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Profile update'),
            content: Text('Congratulations! your profile information has been saved successfully.'),
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
