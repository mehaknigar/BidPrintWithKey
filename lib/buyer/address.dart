import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/repository.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool _isInAsyncCall = false;
  String addr;
  String address, city, code, country, state;
  TextEditingController _fcontroller;
  String check;
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
      appBar: TopBar().getAppBar(
          Icon(Icons.exit_to_app, color: transparent), "ADD ADDRESS", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: themebtn,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Form(
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    MyFormField(
                      45,
                      TextFormField(
                        controller: _fcontroller,
                        onChanged: (value) {
                          address = value;
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: signForm("Address*", null),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MyFormField(
                            45,
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                city = value;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("city*", null),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MyFormField(
                            45,
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                code = value;
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("Postal Code*", null),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10.0),
                      ////////////////////COUNTRY + ZONE////////////////////
                      /////////////////////////////////////////////////////
                      /////////////////////////////////////////////////////

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Make this address your Default address?",
                                  style: TextStyle(fontSize: 15),
                                ),
                                RadioButtonGroup(
                                    labels: <String>[
                                      "Yes",
                                      "No",
                                    ],
                                    onSelected: (String selected) {
                                      addr = selected;
                                      if (selected == "Yes") {
                                        addr = "1";
                                      } else {
                                        addr = "0";
                                      }
                                      print(addr);
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AccountButton(() async {
                        if (address == null ||
                            city == null ||
                            code == null ||
                            _selectedState == null ||
                            _selectedLGA == null ||
                            addr == null) {
                          validation('Note:', "Please provide all the values..",
                              context);
                        } else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            adress();
                          } else {
                            validation(
                                'Failed:',
                                "Try again later or Check your network Connection..",
                                context);
                          }
                        }
                      }, "Add", themeColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  adress() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userID = prefs.getString('userID');
    print(userID);
    var response;
    if (email == null && userID == null) {
      return null;
    }

    response = await http.post(addaddressurl, body: {
      "id": userID,
      "address": address,
      "city": city,
      "code": code,
      "country": _selectedState,
      "zone": _selectedLGA,
      "default": addr
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        _isInAsyncCall = false;
      });
    }
  }
}
