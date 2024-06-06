import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DBHelper {
  var dbReference = FirebaseDatabase.instance.reference();

  getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }


  saveUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
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

  saveProfileInfo(profileMap) {
    FirebaseFirestore.instance
        .collection("userprofile")
        .add(profileMap)
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

  getProfileInfoByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("userprofile")
        .where("email", isEqualTo: userEmail)
        .get();
  }


  saveSubjectInfo(subjectInfoMap) {
    FirebaseFirestore.instance
        .collection("student_subjects")
        .add(subjectInfoMap)
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

  getSubjectInfoByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("student_subjects")
        .get()
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

  getSubjectInfoByTeacherEmailForResult(String email) async {
    return FirebaseFirestore.instance
        .collection("student_subjects")
        .where("teacherEmail", isEqualTo: email)
        .get()
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

  getSubjectInfoByTeacherEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("subjects")
        .where("email", isEqualTo: email)
        .get()
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