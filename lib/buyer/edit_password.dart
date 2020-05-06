import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../bars/topbar.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isInAsyncCall = false;
  String pass, confirm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(Icon(Icons.lock,color: transparent,), "",null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: themebtn,
        progressIndicator: CircularProgressIndicator(),
        child:  Stack(
          fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30),
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Update Password".
                          toUpperCase(),style:
                                  TextStyle(fontSize: 28, color:themebutton,fontWeight: FontWeight.w600)),
                      
                        Padding(
                          padding: const EdgeInsets.only(top:40.0),
                          child: MyFormField(
                            45,
                            TextFormField(
                              obscureText: true,
                              onChanged: (value) {
                                pass = value;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("Password*",Icon(Icons.lock)),
                            ),
                          ),
                        ),
                        MyFormField(
                          45,
                          TextFormField(
                            obscureText: true,
                            onChanged: (value) {
                              confirm = value;
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            decoration: signForm("Confirm Password*",Icon(Icons.lock)),
                          ),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: AccountButton(() async {
                            if (pass == null) {
                              validation('Note:', "Please enter a password..",context);
                            } else if (pass.length < 2 || pass != confirm) {
                              validation('Note:', "Password do not match..",context);
                            } else {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi) {
                                print("$pass $confirm");
                                register();
                              } else {
                                validation('Failed:',
                                    "Try again later or Check your network Connection..",context);
                              }
                            }
                          }, "Update", themeColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  register() async {
      setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userID = prefs.getString('userID');
    var user = prefs.getString('user');
    print(userID);
    if (email == null && userID == null) {
      return null;
    } else {
      var response = await http.post(updatepasswordurl, body: {
        "id": userID,
        "pass": pass,
        "user": user,
      });
      if (response.statusCode == 200) {
        Navigator.pop(context);
        validation('Note:', "Your password has been updated successfully.",context);
        setState(() {
        _isInAsyncCall = false;
      });
      }
    }
  }

}
