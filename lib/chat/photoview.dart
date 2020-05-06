import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class FullPhoto extends StatefulWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  _FullPhotoState createState() => _FullPhotoState();
}

class _FullPhotoState extends State<FullPhoto> {
  double contHeight = 0, contWidth = 0;
  bool downloading = false;
  IconData downloadIcon = Icons.file_download;

  void hideText() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        setState(() {
          contHeight = contWidth = 0;
          downloadIcon = Icons.file_download;
        });
      },
    );
  }

  void downloadImage() async {
    //var response = await http.get(widget.url);


    // var filePath =
    //     await ImagePickerSaver.saveFile(fileData: response.bodyBytes);

    //var savedFile = File.fromUri(Uri.file(filePath));
    await ImageDownloader.downloadImage(widget.url);
    setState(() {
      //Future<File>.sync(() => savedFile);
      downloading = false;
      contWidth = 85;
      contHeight = 20;
      downloadIcon = Icons.check_circle;
    });
    hideText();
  }

  void dialogShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Theme.of(context).accentColor,
            ),
            Text(
              'Image saved in Pictures folder.',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          FullPhotoScreen(url: widget.url),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 0,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 30, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Back',
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      !downloading
                          ? IconButton(
                              tooltip: 'Save Image',
                              icon: Icon(
                                downloadIcon,
                              ),
                              onPressed: () {
                                setState(() {
                                  downloading = true;
                                });
                                downloadImage();
                              },
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                      AnimatedContainer(
                        width: contWidth,
                        height: contHeight,
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          'Downloaded!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => new FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: url,
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}