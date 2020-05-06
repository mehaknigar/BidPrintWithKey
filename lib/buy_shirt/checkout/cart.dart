import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/checkout/confirmOrder.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int size;
  int qnt;
  String userID, subtotal, totalCost, totalShip;
  // int quantity = 001;
  Future<List<CartModel>> _fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(carturl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CartModel> listOfUsers = items.map<CartModel>((json) {
        return CartModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      if (mounted && size > 0) {
        setState(() {
          subtotal = (items[items.length - 1]["subTotal"]).toString();
          totalShip = (items[items.length - 1]["totalShip"]).toString();
          totalCost = (items[items.length - 1]["totalCost"]).toString();
        });
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(Icon(Icons.exit_to_app, color: transparent),
          "Cart".toUpperCase(), null),
      body: FutureBuilder<List<CartModel>>(
        future: _fetchCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (size == 0) {
            return Center(
                child: Text(
              "--No Data Found--",
              style: TextStyle(color: Colors.grey),
            ));
          }
          return Stack(fit: StackFit.expand, children: <Widget>[
            Image.asset(
              "images/BG.png",
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                child: ListView(
                  children: snapshot.data
                      .map(
                        (prod) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Column(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: white,
                                border: Border(
                                  top: BorderSide(
                                      width: 2.0, color: themeshirtbg),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // InkWell(
                                        //   onTap: (){print(prod.ss);},
                                        //   child: Container(
                                        //     padding: EdgeInsets.only(right: 10),
                                        //     height: 50,

                                        //     child: Image.asset(
                                        //         "images/shirts/Blue.png"),
                                        //   ),
                                        // ),
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      height: 300,
                                                      child: CacheImage(
                                                          ("$value/order_image/" +
                                                              prod.ss),
                                                          300)),
                                                ),
                                              );
                                            },
                                            child: CacheImage(
                                                ("$value/order_image/" +
                                                    prod.ss),
                                                80)),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(children: <Widget>[
                                              Text(
                                                "T-Shirt Color:",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                prod.color,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ]),
                                            Row(children: <Widget>[
                                              Text(
                                                "T-Shirt Size:",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                prod.size,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ]),
                                            Row(children: <Widget>[
                                              Text(
                                                "Print Type:",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                child: prod.printType == "Both"
                                                    ? Text(
                                                        prod.printType +
                                                            "- front and back",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      )
                                                    : Text(
                                                        prod.printType,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                              ),
                                            ]),
                                            Container(
                                              child: prod.customText.length > 0
                                                  ? Row(
                                                      children: <Widget>[
                                                        Text(
                                                          "Custom Text:",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "\"" +
                                                              prod.customText +
                                                              "\"",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : null,
                                            ),
                                            Container(
                                              child: prod.customText.length > 0
                                                  ? Row(children: <Widget>[
                                                      // SizedBox(width: 10),
                                                      Text(
                                                        "Font Style:",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        prod.font,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ])
                                                  : null,
                                            ),
                                            Container(
                                              child: prod.customText.length > 0
                                                  ? Row(children: <Widget>[
                                                      Text(
                                                        "Text Color:",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        prod.textColor,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ])
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        color: Colors.red[300],
                                        onPressed: () async {
                                          await http.post(delprourl, body: {
                                            "id": prod.cartid,
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CartPage()));
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: red,
                                          size: 38,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "\$" +
                                        prod.cost +
                                        " * " +
                                        prod.quantity +
                                        " = \$" +
                                        prod.sub,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ]);
        },
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: FlatButton(
                color: Colors.white,
                onPressed: null,
                child: Container(
                  child: subtotal == null
                      ? Text(
                          "Total: \$" + 0.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      : Text(
                          "Total: \$" + subtotal.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: RaisedButton(
                color: themeColor,
                onPressed: () {
                  if (size > 0) {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page:
                                ConfirmOrder(subtotal, totalShip, totalCost)));
                  } else {
                    Fluttertoast.showToast(
                        msg: "You must have atleast one Item to place an order",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
