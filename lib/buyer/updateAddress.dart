import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateAddress extends StatefulWidget {
  final String addressid,

      address,
      city,
      postcode,
      countryName,
      zoneName;
  UpdateAddress(
      this.addressid,

      this.address,
      this.city,
      this.postcode,
      this.countryName,
      this.zoneName);
  @override
  _UpdateAddressState createState() => _UpdateAddressState(
      addressid,

      address,
      city,
      postcode,
      countryName,
      zoneName);
}

class _UpdateAddressState extends State<UpdateAddress> {
  final String addressid,

      address,
      city,
      postcode,
      countryName,
      zoneName;
  _UpdateAddressState(
      this.addressid,

      this.address,
      this.city,
      this.postcode,
      this.countryName,
      this.zoneName);
  bool _isInAsyncCall = false;
  String  add, ct, pstcd, cntryName, znId, znName;
  TextEditingController 
      _addcontroller,
      _ctcontroller,
      _pstcdcontroller,
      _cntryNamecontroller,
      _znNamecontroller;
  String addr;

  myAddress() async {
    setState(() {

      _addcontroller = new TextEditingController(text: address);
      _ctcontroller = new TextEditingController(text: city);
      _pstcdcontroller = new TextEditingController(text: postcode);
      _cntryNamecontroller = new TextEditingController(text: countryName);
      _znNamecontroller = new TextEditingController(text: zoneName);

      add = address;
      ct = city;
      pstcd = postcode;
      cntryName = countryName;
      znName = zoneName;
    });
  }

  @override
  void initState() {
    myAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
       appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30),
              child: Form(
                child: Column(
                  children: <Widget>[
                  
                   
                    MyFormField(
                      45,
                      TextFormField(
                        controller: _addcontroller,
                        onChanged: (value) {
                          add = value;
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        decoration: signForm("Address*",Icon(Icons.business, color: themeColor)),
                      ),
                    ),
                    
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MyFormField(
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
                              decoration: signForm("city*",Icon(Icons.location_city, color: themeColor)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MyFormField(
                            45,
                            TextFormField(
                              controller: _pstcdcontroller,
                              onChanged: (value) {
                                pstcd = value;
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("Postal Code*",Icon(Icons.local_post_office, color: themeColor)),
                            ),
                          ),
                        ),
                      ],
                    ),
                     MyFormField(
                            45,
                            TextFormField(
                              enabled: false,
                              controller: _cntryNamecontroller,
                              onChanged: (value) {
                                cntryName = value;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("Country*",Icon(Icons.location_on, color: themeColor)),
                            ),
                          ),
                       MyFormField(
                            45,
                            TextFormField(
                              enabled: false,
                              controller: _znNamecontroller,
                              onChanged: (value) {
                                znName = value;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              decoration: signForm("Zone*",Icon(Icons.location_on, color: themeColor)),
                            ),
                          ),
                       
                     
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 15.0),
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
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: AccountButton(() async {
                        print(add+ct+pstcd+addr);
                        if (
                            add == null ||
                            ct == null ||
                            pstcd == null || addr == null) {
                          validation('Note:', "Please provide all the values..",context);
                        }  else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                           
                            
                              adress();
                            
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
    if (email == null && userID == null) {
      return null;
    } else {
      var response = await http.post(updateAddressurl, body: {
        "id": userID,
        "addressId": addressid,
        "address": add,
        "city": ct,
        "code": pstcd,
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

  
}
