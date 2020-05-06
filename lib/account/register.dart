import 'dart:convert';
import 'package:bidprint/account/login.dart';
import 'package:bidprint/account/seller_address.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';

class RegisterUser extends StatefulWidget {
  final String user;
  RegisterUser(this.user);
  @override
  _RegisterUserState createState() => _RegisterUserState(user);
}

class _RegisterUserState extends State<RegisterUser> {
  bool _isInAsyncCall = false;
  String fname, lname, email, numb, pass, confirmpass;
  final String user;
  _RegisterUserState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: TopBar().getAppBar(Icon(Icons.exit_to_app, color: transparent),
          user.toUpperCase(), null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: Stack(
          fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      Text("Sign up".toUpperCase(),
                          style: TextStyle(
                              fontSize: 28,
                              color: themeshirt,
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: MyFormField(
                                      45,
                                      TextFormField(
                                        onChanged: (value) {
                                          fname = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: signForm("First",
                                            Icon(Icons.person, color: themeColor)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MyFormField(
                                      45,
                                      TextFormField(
                                        onChanged: (value) {
                                          lname = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: signForm("Last",
                                            Icon(Icons.person, color: themeColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              MyFormField(
                                45,
                                TextFormField(
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Email*",
                                      Icon(Icons.email, color: themeColor)),
                                ),
                              ),
                              MyFormField(
                                45,
                                TextFormField(
                                  onChanged: (value) {
                                    numb = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Telephone +92****",
                                      Icon(Icons.phone, color: themeColor)),
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
                                  decoration: signForm("Password*",
                                      Icon(Icons.lock, color: themeColor)),
                                ),
                              ),
                              MyFormField(
                                45,
                                TextFormField(
                                  onChanged: (value) {
                                    confirmpass = value;
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Confirm Password*",
                                      Icon(Icons.lock, color: themeColor)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, bottom: 20),
                                child: AccountButton(() async {
                                  if (fname == null ||
                                      lname == null ||
                                      email == null ||
                                      numb == null ||
                                      pass == null ||
                                      confirmpass == null) {
                                    validation('Note:',
                                        "Please provide all the values..", context);
                                  } else if (fname.length <= 2 ||
                                      lname.length <= 2) {
                                    validation('Note:',
                                        "Please enter a valid name..", context);
                                  } else if (EmailValidator.validate(email) ==
                                      false) {
                                    validation(
                                        'Note:',
                                        "Please enter a valid email address..",
                                        context);
                                  } else if (int.tryParse(numb) == null) {
                                    validation(
                                        'Note:',
                                        "Please enter a valid Phone Number..",
                                        context);
                                  } else if (pass != confirmpass) {
                                    validation('Note:', "Password do not match..",
                                        context);
                                  } else {
                                    var connectivityResult =
                                        await (Connectivity().checkConnectivity());
                                    if (connectivityResult ==
                                            ConnectivityResult.mobile ||
                                        connectivityResult ==
                                            ConnectivityResult.wifi) {
                                      print(
                                          "$fname $lname $email $numb $pass $confirmpass");
                                      userRegistration();
                                    } else {
                                      validation(
                                          'Failed:',
                                          "Try again later or Check your network Connection..",
                                          context);
                                    }
                                  }
                                }, "Sign Up", themeColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future userRegistration() async {
    setState(() {
      _isInAsyncCall = true;
    });
    if(user=="seller"){
      Navigator.push(context, MaterialPageRoute(builder: ((context) => SellerAddress(fname,lname,email,numb,pass,user))));
    }else{
    var data = {
      'fname': fname,
      'lname': lname,
      'email': email,
      'numb': numb,
      'pass': pass,
      'user': user
    };
    var response = await http.post(registerurl, body: json.encode(data));
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isInAsyncCall = false;
      });
      print("$user  $message");
      // if (message == "User Registered Successfully." && user == "seller") {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => SellerDescription(user,email))));
      // }else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => Login(user))));
      // }
    }

    validation("Note", message, context);
  }
  }
}
