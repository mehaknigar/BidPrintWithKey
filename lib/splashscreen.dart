import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen started");
    Timer(Duration(seconds: 4), finished);
  }

  void finished() async {
    debugPrint("finished");
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
          Center(
              child: 
              Image.asset(
                "images/Logo.png",
                width: 320,
                fit: BoxFit.cover,
              ),
              ),
        ],
      ),
    );
  }
}
