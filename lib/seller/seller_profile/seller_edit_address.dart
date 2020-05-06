import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/repository.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerEditAddress extends StatefulWidget {
  final String company, address, city, post, country, zone;
  SellerEditAddress(this.company, this.address, this.city, this.post,
      this.country, this.zone);
  @override
  _SellerEditAddressState createState() =>
      _SellerEditAddressState(company, address, city, post, country, zone);
}

class _SellerEditAddressState extends State<SellerEditAddress> {
  bool _isInAsyncCall = false;
  final String company, address, city, post, country, zone;
  _SellerEditAddressState(this.company, this.address, this.city, this.post,
      this.country, this.zone);

  Repository repo = Repository();

  List<String> _states = ["Choose a state"];
  List<String> _lgas = ["Choose .."];
  String _selectedState = "Choose a state";
  String _selectedLGA = "Choose ..";

  TextEditingController _compcontroller,
      _addcontroller,
      _ctcontroller,
      _postcontroller;
  String cm, ad, ct, ps, userID, user;
  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    user = prefs.getString('user');

    setState(() {
      userID = userID;
      user = user;
      _compcontroller = new TextEditingController(text: company);
      _addcontroller = new TextEditingController(text: address);
      _ctcontroller = new TextEditingController(text: city);
      _postcontroller = new TextEditingController(text: post);
      cm = company;
      ad = address;
      ct = city;
      ps = post;
      print(cm);
    });
  }

  @override
  void initState() {
    _states = List.from(_states)..addAll(repo.getStates());
    myPrefs();
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
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
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
                      Text("Edit Address".toUpperCase(),
                          style: TextStyle(
                              fontSize: 28,
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
                                  controller: _compcontroller,
                                  onChanged: (value) {
                                    cm = value;
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
                                  controller: _addcontroller,
                                  onChanged: (value) {
                                    ad = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm("Address*",
                                      Icon(Icons.home, color: themeColor)),
                                ),
                              ),
                              MyFormField(
                                45,
                                TextFormField(
                                  controller: _ctcontroller,
                                  onChanged: (value) {
                                    ct = value;
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
                                  controller: _postcontroller,
                                  onChanged: (value) {
                                    ps = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  decoration: signForm(
                                      "Post Code*",
                                      Icon(Icons.local_post_office,
                                          color: themeColor)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.6),
                                        border: Border.all(color: themebutton),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: _states
                                            .map((String dropDownStringItem) {
                                          return DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(
                                              dropDownStringItem,
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.6),
                                        border: Border.all(color: themebutton),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: _lgas
                                            .map((String dropDownStringItem) {
                                          return DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(dropDownStringItem,
                                                style: TextStyle(
                                                    color: Colors.grey[600])),
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
                                  if (cm == null ||
                                      ad == null ||
                                      _selectedLGA == null ||
                                      ct == null ||
                                      ps == null ||
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
                                      print("$ad");
                                      userUpdateAddress();
                                    } else {
                                      validation(
                                          'Failed:',
                                          "Try again later or Check your network Connection..",
                                          context);
                                    }
                                  }
                                }, "Update Address", themeColor),
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

  Future userUpdateAddress() async {
    setState(() {
      _isInAsyncCall = true;
    });
    var response = await http.post(updatesellerAddressurl, body: {
      'id': userID,
      'user': user,
      'company': cm,
      'address': ad,
      'city': ct,
      'post': ps,
      "country": _selectedState,
      "zone": _selectedLGA,
    });

    if (response.statusCode == 200) {
      var data = json.encode(response.body);
      setState(() {
        _isInAsyncCall = false;
      });
      print(" $data");
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/seller');
    }
  }
}
