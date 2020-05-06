import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/repository.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bidprint/account/login.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';

class SellerAddress extends StatefulWidget {
  final String fname, lname, email, numb, pass, user;
  SellerAddress(
      this.fname, this.lname, this.email, this.numb, this.pass, this.user);
  @override
  _SellerAddressState createState() =>
      _SellerAddressState(fname, lname, email, numb, pass, user);
}

class _SellerAddressState extends State<SellerAddress> {
  bool _isInAsyncCall = false;
  String address, city, post, company;
  final String fname, lname, email, numb, pass, user;
  _SellerAddressState(
      this.fname, this.lname, this.email, this.numb, this.pass, this.user);

    Repository repo = Repository();

  List<String> _states = ["Choose a state"];
  List<String> _lgas = ["Choose .."];
  String _selectedState = "Choose a state";
  String _selectedLGA = "Choose ..";

  @override
  void initState() {
    _states = List.from(_states)..addAll(repo.getStates());
    super.initState();
  }

  void _onSelectedState(String value) {
    setState(() {
      _selectedLGA = "Choose ..";
      _lgas = ["Choose .."];
      _selectedState = value;
      _lgas = List.from(_lgas)..addAll(repo.getLocalByState(value));
    });
  }

  void _onSelectedLGA(String value) {
    setState(() => _selectedLGA = value);
  }
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
          fit: StackFit.expand,
          children: <Widget>[
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
                      Text("You are just one step away..".toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              color: themeshirt,
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              MyFormField(
                                45,
                                TextFormField(
                                  onChanged: (value) {
                                    company = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Company name*",
                                      Icon(Icons.business, color: themeColor)),
                                ),
                              ),
                              MyFormField(
                                      45,
                                      TextFormField(
                                        onChanged: (value) {
                                          address = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: signForm(
                                            "Address*",
                                            Icon(Icons.home,
                                                color: themeColor)),
                                      ),
                                    ),
                                  MyFormField(
                                      45,
                                      TextFormField(
                                        onChanged: (value) {
                                          city = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: signForm(
                                            "City*",
                                            Icon(Icons.location_city,
                                                color: themeColor)),
                                      ),
                                    ),
                                
                              MyFormField(
                                45,
                                TextFormField(
                                  onChanged: (value) {
                                    post = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Post Code*",
                                      Icon(Icons.local_post_office, color: themeColor)),
                                ),
                              ),
                              
                              Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10.0),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              border: Border.all(color: themebutton),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              items: _states.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onSelectedState(value);
                                print(_selectedState);
                              },
                              value: _selectedState,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              border: Border.all(color: themebutton),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              items: _lgas.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem,
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onSelectedLGA(value);
                                print(_selectedLGA);
                              },
                              value: _selectedLGA,
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 20),
                                child: AccountButton(() async {
                                  if (address == null ||
                                      _selectedLGA == null ||
                                      city == null ||
                                      post == null ||
                                      _selectedState == null) {
                                    validation(
                                        'Note:',
                                        "Please provide all the values..",
                                        context);
                                  } else {
                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                            ConnectivityResult.mobile ||
                                        connectivityResult ==
                                            ConnectivityResult.wifi) {
                                      print(
                                          "$fname $lname $email $numb $pass ");
                                      userRegistration();
                                    } else {
                                      validation(
                                          'Failed:',
                                          "Try again later or Check your network Connection..",
                                          context);
                                    }
                                  }
                                }, "Done", themeColor),
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
    var data = {
      'fname': fname,
      'lname': lname,
      'email': email,
      'numb': numb,
      'pass': pass,
      'user': user,
      'company': company,
      'address':address,
      'city':city,
      'post':post,
      "country": _selectedState,
      "zone": _selectedLGA,

    };
    var response = await http.post(registerurl, body: json.encode(data));
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isInAsyncCall = false;
      });
      print("$user  $message");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => Login(user))));

    }

    validation("Note", message, context);
  }
}
