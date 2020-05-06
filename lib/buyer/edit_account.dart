import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool _isInAsyncCall = false;
  String fname, lname, email, numb,user;
  String userID, fprefs, lprefs, numberprefs, emailprefs;
  TextEditingController _fcontroller,
      _lcontroller,
      _emailcontroller,
      _numbcontroller;
  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailprefs = prefs.getString('email');
    fprefs = prefs.getString('fname');
    lprefs = prefs.getString('lname');
    numberprefs = prefs.getString('number');
    user = prefs.getString('user');
    setState(() {
      _fcontroller = new TextEditingController(text: fprefs);
      _lcontroller = new TextEditingController(text: lprefs);
      _emailcontroller = new TextEditingController(text: emailprefs);
      _numbcontroller = new TextEditingController(text: numberprefs);
      fname=fprefs; lname=lprefs; email=emailprefs; numb=numberprefs;
      print(fname+lname);
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
      appBar: TopBar().getAppBar(Icon(Icons.exit_to_app,color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                       Text("Edit Account".toUpperCase(),style:
                                  TextStyle(fontSize: 28, color:themebutton,fontWeight: FontWeight.w600)),
                       
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: MyFormField(
                            45,
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                fname = value;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("First*",Icon(Icons.person, color: themebutton)),
                            ),
                          ),
                        ),
                        MyFormField(
                          45,
                          TextFormField(
                            controller: _lcontroller,
                            onChanged: (value) {
                              lname = value;
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            decoration: signForm("Last*",Icon(Icons.person, color: themebutton)),
                          ),
                        ),
                        MyFormField(
                          45,
                          TextFormField(
                            controller: _emailcontroller,
                            onChanged: (value) {
                              email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            decoration: signForm("Email*",Icon(Icons.email, color: themebutton)),
                          ),
                        ),
                        MyFormField(
                          45,
                          TextFormField(
                            controller: _numbcontroller,
                            onChanged: (value) {
                              numb = value;
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            decoration: signForm("Telephone*",Icon(Icons.phone, color: themebutton)),
                          ),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: AccountButton(() async {
                            if (fname == null ||
                                lname == null ||
                                email == null ||
                                numb == null) {
                              validation('Note:', "Please provide all the values..",context);
                            } else if (fname.length <= 2 || lname.length <= 2) {
                              validation('Note:', "Please enter a valid name..",context);
                            } else if (EmailValidator.validate(email) == false) {
                              validation(
                                  'Note:', "Please enter a valid email address..",context);
                            } else if (int.tryParse(numb) == null) {
                              validation(
                                  'Note:', "Please enter a valid Phone Number..",context);
                            } else {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi) {
                                print("$fname $lname $email $numb ");
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

  String f, l, e, n, i;
  register() async {
    setState(() {
        _isInAsyncCall = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    print(userID);
    if (userID == null) {
      return null;
    } else {
      var response = await http.post(editAccounturl, body: {
        "id": userID,
        "first": fname,
        "last": lname,
        "email": email,
        "numb": numb,
        "user": user
      });
      if (response.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body);
      if (user == "buyer") {
        i = data[0]["customer_id"];
      } else if (user == "seller") {
        i = data[0]["seller_id"];
      }
        e = data[0]["email"];
        f = data[0]["firstname"];
        l = data[0]["lastname"];
        n = data[0]["telephone"];
        _savePreference().then((bool committed) {
          validation('Note:', "Your account has been updated successfully.",context);
        });
        setState(() {
          _isInAsyncCall = false;
        });
      }
    }
  }

  Future<bool> _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", e);
    prefs.setString("userID", i);
    prefs.setString("fname", f);
    prefs.setString("lname", l);
    prefs.setString("number", n);
    print(prefs);
    return prefs.commit();
  }

}
