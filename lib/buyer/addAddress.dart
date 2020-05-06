import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buyer/updateAddress.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  int size;
  var userID;
  Future<List<Adress>> _fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(addressurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Adress> listOfUsers = items.map<Adress>((json) {
        return Adress.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: FutureBuilder<List<Adress>>(
        future: _fetchAddress(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (size == 0) {
            return Center(
                child: Text(
              "--No Address Found--",
              style: TextStyle(color: Colors.grey),
            ));
          }
          return Container(
            child: ListView(
              children: snapshot.data
                  .map((address) => Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: white,
                            border: Border(
                              top: BorderSide(width: 2.0, color: themeshirtbg),
                            ),
                          ),
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
                                  Text(address.address,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  OutlineButton(
                                    highlightColor: Colors.blue.shade100,
                                    borderSide:
                                        BorderSide(color: Colors.green[700]),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateAddress(
                                                      address.addressid,
                                                      address.address,
                                                      address.city,
                                                      address.postcode,
                                                      address.countryName,
                                                      address.zoneName)));
                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 12),
                                    ),
                                  ),
                                  OutlineButton(
                                    highlightColor: Colors.red.shade100,
                                    borderSide:
                                        BorderSide(color: Colors.red[700]),
                                    onPressed: () async {
                                      await http.post(deleteaddressurl, body: {
                                        "id": address.addressid,
                                        "userId": userID
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAddress()));
                                    },
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(
                                          color: Colors.red[700], fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        width: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: FlatButton(
                onPressed: null,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: RaisedButton(
                color: themeColor,
                onPressed: () {
                  Navigator.pushNamed(context, "/addaddress");
                },
                child: Text(
                  "Add Address",
                  style: TextStyle(color: skinColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
