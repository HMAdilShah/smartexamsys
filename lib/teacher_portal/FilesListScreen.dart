import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FilesListScreen extends StatelessWidget {
  final String folderPath;
  final String fileType;

  FilesListScreen({required this.folderPath, required this.fileType});

  Future<List<String>> getFilesList() async {
    List<String> filesList = [];

    firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance
        .ref(folderPath)
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      if (ref.name.endsWith(fileType)) {
        filesList.add(ref.name);
      }
    });

    return filesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files List'),
      ),
      body: FutureBuilder<List<String>>(
        future: getFilesList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No files found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String fileName = snapshot.data![index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(fileName),
                    onTap: () {
                      if(fileType=="mp4"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FileViewScreenVideo(
                              filePath: '$folderPath/$fileName',
                            ),
                          ),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FileViewScreenTxt(
                              filePath: '$folderPath/$fileName',
                            ),
                          ),
                        );
                      }
                      // Navigate to a screen to view the file

                    },
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}

class FileViewScreenTxt extends StatelessWidget {
  final String filePath;

  FileViewScreenTxt({required this.filePath});

  Future<String> fetchTextFileContent() async {
    dynamic fileData = await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .getData();
    return String.fromCharCodes(fileData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Viewer'),
      ),
      body: FutureBuilder<String>(
        future: fetchTextFileContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Text(
                snapshot.data!,
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}





class FileViewScreenVideo extends StatefulWidget {
  final String filePath;

  FileViewScreenVideo({required this.filePath});

  @override
  _FileViewScreenState createState() => _FileViewScreenState();
}

class _FileViewScreenState extends State<FileViewScreenVideo> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/video.mp4');

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(widget.filePath);
      await ref.writeToFile(file);

      _controller = VideoPlayerController.file(file);
      _initializeVideoPlayerFuture = _controller?.initialize().then((_) {
        setState(() {});
      });
    } catch (error) {
      print("Error downloading and initializing video: $error");
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Viewer'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done && _controller != null) {
            final chewieController = ChewieController(
              videoPlayerController: _controller!,
              autoPlay: true,
              looping: false, // Set to true if you want the video to loop
            );

            return Center(
              child: Chewie(controller: chewieController),
            );
          } else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text('Video player is not ready.')
              ],
            ));
          }
        },
      ),
    );
  }

}


