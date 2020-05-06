import 'dart:convert';
import 'package:bidprint/account/register.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'forgot_password.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  final String user;
  Login(this.user);
  @override
  _LoginState createState() => _LoginState(user);
}

class _LoginState extends State<Login> {
  final String user;
  _LoginState(this.user);
  String email, pass;
  bool _isInAsyncCall = false;
  Future<bool> _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("userID", userID);
    prefs.setString("fname", fname);
    prefs.setString("lname", lname);
    prefs.setString("number", number);
    prefs.setString("user", user);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(Icon(Icons.exit_to_app, color: transparent),
          user.toUpperCase(), null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 30),
                    child: Image.asset(
                      "images/logoblack.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          MyFormField(
                            45,
                            TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              decoration: signForm("Email",
                                  Icon(Icons.email, color: themebutton)),
                            ),
                          ),
                          MyFormField(
                            45,
                            TextFormField(
                              onChanged: (value) {
                                pass = value;
                              },
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              decoration: signForm("Password",
                                  Icon(Icons.lock, color: themebutton)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ForgotPassword(user))));
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: themebutton,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AccountButton(() async {
                    if (email == null || pass == null) {
                      validation(
                          'Note:', "Please provide all the values..", context);
                    } else {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        login();
                      } else {
                        validation(
                            'Failed:',
                            "Try again later or Check your network Connection..",
                            context);
                      }
                    }
                  }, "Sign In", themeColor),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      "OR",
                      style: TextStyle(color: color2),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     CircleAvatar(
                  //       radius: 25,
                  //       backgroundColor: Colors.white,
                  //       child: GestureDetector(
                  //         onTap: () {},
                  //         child: Image.asset(
                  //           'images/fb-icon.png',
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 15),
                  //     CircleAvatar(
                  //       radius: 25,
                  //       backgroundColor: Colors.white,
                  //       child: GestureDetector(
                  //         onTap: () {},
                  //         child: Image.asset(
                  //           'images/g-icon.png',
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        RegisterUser(user))));
                          },
                          child: Text(
                            "I'm New, Create Account",
                            style: TextStyle(
                                color: themebutton,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String userID, fname, lname, number;
  Future<void> login() async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http
        .post(loginurl, body: {"email": email, "password": pass, "user": user});

    var data = json.decode(response.body);
    if (data.length == 0) {
      validation("Note:", "Login Failed, Try Again..", context);
      setState(() {
        _isInAsyncCall = false;
      });
    } else {
      print(response.body);
      if (user == "buyer") {
        userID = data[0]["customer_id"];
      } else if (user == "seller") {
        userID = data[0]["seller_id"];
      }
      fname = data[0]["firstname"];
      lname = data[0]["lastname"];
      number = data[0]["telephone"];

      _savePreference().then((bool committed) {
        _firebaseMessaging.subscribeToTopic('all');
        _firebaseMessaging.subscribeToTopic('$userID-$user');
        _firebaseMessaging.subscribeToTopic('$userID-$user-order');
        _firebaseMessaging.subscribeToTopic('$userID-$user-chat');
        // if (user == "buyer") {
        // Navigator.pushReplacementNamed(context, "/buyer");
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       '/buyer', (Route<dynamic> route) => false);
        // } else {
        // Navigator.pushReplacementNamed(context, "/seller");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        // }

        setState(() {
          _isInAsyncCall = false;
        });
      });
    }
  }
}
