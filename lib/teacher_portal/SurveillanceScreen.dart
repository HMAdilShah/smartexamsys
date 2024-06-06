import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartexamsys/teacher_portal/FilesListScreen.dart';

class SurveillanceScreen extends StatelessWidget {
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFff800a),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Text(
                'Surveillance of Exam',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          child: IconButton(
                            iconSize: 80,
                            icon: Icon(Icons.camera_alt, color: Color(0xFFDB3022)),
                            onPressed: () {
                              showToast("Camera functionality is in development.");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Open Camera',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),*/
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          child: IconButton(
                            iconSize: 80,
                            icon: Icon(Icons.play_arrow, color: Color(0xFFDB3022)),
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: "Please wait...",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );

                              // showToast("Recording playback is in development.");
                              _navigateToFilesList(context, 'videos', 'mp4');

                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Show Recordings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: IconButton(
                        iconSize: 80,
                        icon: Icon(Icons.receipt, color: Color(0xFFDB3022)),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "Please wait...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                          // showToast("View reports functionality is in development.");
                          _navigateToFilesList(context, 'reports', 'txt');

                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'View Reports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFilesList(BuildContext context, String folderPath, String fileType) async {
    List<Reference> files = await FirebaseStorageAccess.fetchFilesInFolder(folderPath);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilesListScreen(folderPath: folderPath, fileType: fileType,)),
    );
  }

}


class FirebaseStorageAccess {
  static Future<List<Reference>> fetchFilesInFolder(String folderPath) async {
    List<Reference> files = [];

    Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);
    ListResult result = await folderRef.listAll();

    files = result.items;

    return files;
  }
}