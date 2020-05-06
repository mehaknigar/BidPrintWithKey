import 'dart:convert';
import 'package:bidprint/account/utils/code.dart';
import 'package:bidprint/account/utils/verify.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  final String user;
  ForgotPassword(this.user);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState(user);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final String user;
  _ForgotPasswordState(this.user);

  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.4,
          color: skinColor,
          progressIndicator: CircularProgressIndicator(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "images/no_message.jpg",
                    width: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: Text(
                      "Forgot Your Password?",
                      style: TextStyle(
                          color: red,
                          fontWeight: FontWeight.w600,
                          fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Text(
                      "Enter your mail below to receive your password reset instructions",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Form(
                    child: MyFormField(
                      45,
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        decoration: signForm(
                            "Email", Icon(Icons.email, color: themeColor)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: AccountButton(() async {
                      if (email == null) {
                        validation(
                            'Note:', "Please enter the Email..", context);
                      } else {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          // openUrl();
                          _verifyEmail();
                        } else {
                          validation(
                              'Failed:',
                              "Try again later or Check your network Connection..",
                              context);
                        }
                      }
                    }, "Submit",
                        themeColor), //"Send a verification code", themeColor),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool _isInAsyncCall = false;
  _verifyEmail() async {
    setState(() {
      _isInAsyncCall = true;
    });
    var response = await http.post(phoneVerifyurl, body: {
      "user": user,
      "email": email,
    });

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      if (data.length == 0) {
        validation(
            "Note:",
            "Something went wrong, Please contact with our Customer Service",
            context);
        setState(() {
          _isInAsyncCall = false;
        });
      } else {
        print(response.body);
        var phone = data[0]["telephone"];
        startPhoneAuth(phone);
        
      }
    }
  }

  startPhoneAuth(phone) {
    setState(() {
          _isInAsyncCall = false;
        });
    FirebasePhoneAuth.instantiate(phoneNumber: phone);

    Navigator.of(context).push(CupertinoPageRoute(
        builder: (BuildContext context) => PhoneAuthVerify(email, user)));
  }
}
