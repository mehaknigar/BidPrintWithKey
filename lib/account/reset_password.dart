import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final String email, user;
  ResetPassword(this.email, this.user);
  @override
  _ResetPasswordState createState() => _ResetPasswordState(email, user);
}

class _ResetPasswordState extends State<ResetPassword> {
  final String email, user;
  _ResetPasswordState(this.email, this.user);
  bool _isInAsyncCall = false;
  String name, pass, confirmPass;
  TextEditingController _controller;
  myPrefs() async {
    setState(() {
      _controller = new TextEditingController(text: email);
      name = email;
      print(email);
    });
  }

  @override
  void initState() {
    super.initState();
    myPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20),
            child: Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 50),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: themebtn),
                    ),
                  ),
                  MyFormField(
                    45,
                    TextFormField(
                      controller: _controller,
                      readOnly: true,
                      onChanged: (value) {
                        name = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      decoration: signForm("Your Email*", null),
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
                        color: Colors.grey[700],
                      ),
                      decoration: signForm("New Password*", null),
                    ),
                  ),
                  MyFormField(
                    45,
                    TextFormField(
                      onChanged: (value) {
                        confirmPass = value;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      decoration: signForm("Confirm Password*", null),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: AccountButton(() async {
                      print(name);
                      if (name == null || pass == null || confirmPass == null) {
                        validation(
                            'Note:', "Please provide all the values..", context);
                      } else if (pass.length <= 2 || confirmPass.length <= 2) {
                        validation(
                            'Note:', "Please enter a length of > 2..", context);
                      } else if (pass != confirmPass) {
                        validation('Note:', "Passwords do not match..", context);
                      } else {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          print("$name $pass");
                          resetPass();
                        } else {
                          validation(
                              'Failed:',
                              "Try again later or Check your network Connection..",
                              context);
                        }
                      }
                    }, "Send", themeColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetPass() async {
    setState(() {
      _isInAsyncCall = true;
    });

    var response = await http.post(resetPassurl, body: {
      "email": name,
      "pass": pass,
      "user": user,
    });
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      myToast("Password updated successfully");
      setState(() {
        _isInAsyncCall = false;
      });
    } else {
      validation("Note", "Something went wrong", context);
    }
  }
}
