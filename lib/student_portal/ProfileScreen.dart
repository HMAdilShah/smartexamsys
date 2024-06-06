import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/database/SaveInSharedPref.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sapIdController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  String email = "";
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  void loadProfileData() async {

    email = (await SaveInSharedPref.getUserEmailPreference())!;
    QuerySnapshot profileSnapshot = await getProfileInfoByEmail(email!);

    if (profileSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = profileSnapshot.docs[0].data() as Map<String, dynamic>;

      nameController.text = userData['name'] ?? '';
      sapIdController.text = userData['sapid'] ?? '';
      departmentController.text = userData['department'] ?? '';
      semesterController.text = userData['semester'] ?? '';

      setState(() {
        isDataLoaded = true;
      });
    }
  }

  Future<QuerySnapshot> getProfileInfoByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("userprofile")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  void saveProfileInfo() {
    Map<String, String> profileMap = {
      "name": nameController.text,
      "email": email,
      "sapid": sapIdController.text,
      "department": departmentController.text,
      "semester": semesterController.text,
    };

    FirebaseFirestore.instance
        .collection("userprofile")
        .add(profileMap)
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
    }).catchError((e) {
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
              controller: sapIdController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'SAP ID',
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
            SizedBox(height: 10),
            TextField(
              controller: semesterController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Semester',
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
                    saveProfileInfo();
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
}
