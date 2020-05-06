import 'dart:convert';
import 'dart:math';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/address/changeAddress.dart';
import 'package:bidprint/buy_shirt/vendors.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';

class ShippingAddress extends StatefulWidget {
  final String photo,printtype,
      dopdownShirtStyle,
      dropdownShirtColor,
      design,
      dropdownShirtSize,
      name,
      colorString,
      font,
      base64Image,
      imageFile,
      shape;
  final bool bend;
  final int quantity;
  ShippingAddress(this.photo,
      this.printtype,
      this.dopdownShirtStyle,
      this.bend,
      this.dropdownShirtColor,
      this.design,
      this.quantity,
      this.dropdownShirtSize,
      this.name,
      this.colorString,
      this.font,
      this.base64Image,
      this.imageFile,
      this.shape);
  @override
  _ShippingAddressState createState() => _ShippingAddressState(photo,
      printtype,
      dopdownShirtStyle,
      bend,
      dropdownShirtColor,
      design,
      quantity,
      dropdownShirtSize,
      name,
      colorString,
      font,
      base64Image,
      imageFile,
      shape);
}

class _ShippingAddressState extends State<ShippingAddress> {
  final String photo,printtype,
      dopdownShirtStyle,
      dropdownShirtColor,
      design,
      dropdownShirtSize,
      name,
      colorString,
      font,
      base64Image,
      imageFile,
      shape;
  final bool bend;
  final int quantity;
  _ShippingAddressState(this.photo,
      this.printtype,
      this.dopdownShirtStyle,
      this.bend,
      this.dropdownShirtColor,
      this.design,
      this.quantity,
      this.dropdownShirtSize,
      this.name,
      this.colorString,
      this.font,
      this.base64Image,
      this.imageFile,
      this.shape);
  int size;
  String first, last;
  Future<List<Adress>> _fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    first = prefs.getString('fname');
    last = prefs.getString('lname');
    var response = await http.post(shippingAddressurl, body: {
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
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.4,
          color: skinColor,
          progressIndicator: CircularProgressIndicator(),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FutureBuilder<List<Adress>>(
                    future: _fetchAddress(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if (size == 0) {
                        return Center(
                            child: RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pushNamed(context, "/addaddress");
                          },
                          child: Text(
                            "--Add address--",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }
                      return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                              children: snapshot.data
                                  .map((address) => Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "Shipping Address",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeshirt),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Name:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(first + " " + last,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Address:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(address.address,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "City:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(address.city,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Post code:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(address.postcode,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Country:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(address.countryName,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Region / State:  ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(address.zoneName,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  OutlineButton(
                                                    highlightColor:
                                                        Colors.orange.shade200,
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/addaddress");
                                                    },
                                                    child: Text(
                                                      "Add New",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  OutlineButton(
                                                    highlightColor:
                                                        Colors.blue.shade200,
                                                    borderSide: BorderSide(
                                                        color: Colors.blue),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChangeAddress()));
                                                    },
                                                    child: Text(
                                                      "Select",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Divider(
                                                thickness: 2,
                                                color: themeColor,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 20),
                                              child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: FlatButton.icon(
                                                    color: themeColor,
                                                    onPressed: () {
                                                      if (size > 0) {
                                                        addTShirtColor(
                                                            address.address,
                                                            address.city,
                                                            address.postcode,
                                                            address.countryName,
                                                            address.zoneName);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please select an address before you proceed..",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.black,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                    },
                                                    label: Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                          color: skinColor),
                                                    ),
                                                    icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                        color: skinColor),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()));
                    }),
              ),
            ],
          ),
        ));
  }

  String sellerID;
  var response;
  var data;
  int random() {
    var rng = Random();
    int a;
    for (var i = 0; i < 10; i++) {
      a = rng.nextInt(100000000);
    }
    return a;
  }

  bool _isInAsyncCall = false;
  addTShirtColor(address, city, postcode, countryName, zoneName) async {
    setState(() {
      _isInAsyncCall = true;
    });
    String randomNumber = random().toString();
    String ssNumber = random().toString();
    print(imageFile);
    print(colorString);
    print(photo);
    response = await http.post(getBuyerColorurl, body: {
      "address": address,
      "city": city,
      "post": postcode,
      "country": countryName,
      "zone": zoneName,
      "print_type": printtype,
      "shirt_style": dopdownShirtStyle,
      "text_type": name != "" ? bend == true ? "bend" : "straight" : '',
      "colors": dropdownShirtColor,
      "design_type": design,
      "quantity": quantity.toString(),
      "size": dropdownShirtSize,
      "text": name == '' ? '' : name,
      "textColor": name == '' ? '' : colorString,
      "font": name == '' ? '' : font,
      "image": imageFile == null ? '' : base64Image,
      "imageName": imageFile == null ? '' : randomNumber + '_' + imageFile,
      'shape': shape == '' ? '' : shape,
      'ssName': 'screenshot-$ssNumber.png',
      'ssImage': photo
    });
    print(response);
    if (response.statusCode == 200) {
      print('check');
      data = json.decode(response.body);
      print(data);
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => ShowVendors(data))));
      setState(() {
        _isInAsyncCall = false;
      });
    }
  }
}
