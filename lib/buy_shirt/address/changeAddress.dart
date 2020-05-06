import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';

class ChangeAddress extends StatefulWidget {
  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  Future<List<Adress>> _fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    var response = await http.post(addressurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Adress> listOfUsers = items.map<Adress>((json) {
        return Adress.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }
bool _isInAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: FutureBuilder<List<Adress>>(
          future: _fetchAddress(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Container(
              child: ListView(
                children: snapshot.data
                    .map((address) => Card(
                          child: ListTile(
                            subtitle: Column(children: <Widget>[
                            
                                 Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Address:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      address.address,
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "City:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(address.city,
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Post code:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(address.postcode,
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Country:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(address.countryName,
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Region / State:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(address.zoneName,
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    color: themeColor,
                                    onPressed: () async {
                                      setState(() {
                                        _isInAsyncCall=true;
                                      });
                                      SharedPreferences prefs=await SharedPreferences.getInstance();
                                      String userID = prefs.getString("userID");
                                      final response = await http
                                          .post(changeAddressurl, body: {
                                        "id": userID,
                                        "addressId": address.addressid,
                                      });
                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _isInAsyncCall = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Address Selected Successfully..",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                            Navigator.pop(context);
                                      } else {
                                        _isInAsyncCall=false;
                                        Fluttertoast.showToast(
                                            msg: "Failed to load..",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        throw Exception(
                                            'Failed to load internet');
                                      }
                                    },
                                    child: Text(
                                      "Select",
                                      style: TextStyle(color: skinColor),
                                    ),
                                  )
                                ],
                              )
                            ]),
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
