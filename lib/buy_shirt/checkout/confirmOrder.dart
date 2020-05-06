import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/checkout/place_order.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';

class ConfirmOrder extends StatefulWidget {
  final String subtotal, totalShip, totalCost;

  ConfirmOrder(this.subtotal, this.totalShip, this.totalCost);
  @override
  _ConfirmOrderState createState() =>
      _ConfirmOrderState(subtotal, totalShip, totalCost);
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  final String subtotal, totalShip, totalCost;

  _ConfirmOrderState(this.subtotal, this.totalShip, this.totalCost);
  String userID = "", email = "", fname = "", lname = "", number = "";
  _getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');
    var em = prefs.getString("email");
    var fn = prefs.getString("fname");
    var ln = prefs.getString("lname");
    var nm = prefs.getString("number");
    if (em == null || fn == null || ln == null) {
      return null;
    } else {
      setState(() {
        userID = id;
        email = em;
        fname = fn;
        lname = ln;
        number = nm;
      });
    }

    print(userID);
    print(subtotal);
  }

  List sellerIDs = [];
  List data = [];

  int size;
  Future<List<CartModel>> _fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(carturl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      data.clear();
      sellerIDs.clear();
      data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        sellerIDs.add(data[i]['seller_id']);
      }
      print('seller ids: $sellerIDs');
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CartModel> listOfUsers = items.map<CartModel>((json) {
        return CartModel.fromJson(json);
      }).toList();
      print(response.body);
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: TopBar().getAppBar(
            Icon(Icons.exit_to_app, color: transparent), "Order Detail", null),
        body: FutureBuilder<List<CartModel>>(
            future: _fetchCart(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Name:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 23),
                                    Text(fname + " " + lname,
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Email:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 25),
                                    Text(email, style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Phone:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 20),
                                    Text(number,
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Item Detail",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: themeshirt),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      snapshot.data
                          .map((prod) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: white,
                                        border: Border(
                                          top: BorderSide(
                                              width: 2.0, color: themeshirtbg),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    child: Container(
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
                                                  child:
                                                      prod.printType == "Both"
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
                                                child: prod.customText.length >
                                                        0
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
                                                child: prod.customText.length >
                                                        0
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
                                                child: prod.customText.length >
                                                        0
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                              child: Text(
                                                  prod.address +
                                                      "\n" +
                                                      prod.city +
                                                      " , " +
                                                      prod.zone +
                                                      " , " +
                                                      prod.country,
                                                  softWrap: true)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "\$" +
                                                prod.cost +
                                                " * " +
                                                prod.quantity +
                                                " = \$" +
                                                prod.sub,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: themebutton),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "United Parcel Service:- ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF22548a),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "SubTotal:  ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(width: 10),
                                    Text("\$" + subtotal,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Shipping Rate:  ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      totalShip,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.green[500],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Total Cost:  \$" + totalCost,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF22548a)),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
        bottomNavigationBar: Container(
          width: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  color: transparent,
                  onPressed: null,
                  child: Text(
                    "Total Cost:  \$" + totalCost,
                    style: TextStyle(fontSize: 15, color: black),
                  ),
                ),
              ),
              Expanded(
                child: RaisedButton(
                  color: themeColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: PlaceOrder(
                                userID, subtotal, totalShip, totalCost, sellerIDs)));
                  },
                  child: Text(
                    "Continue to Payment",
                    style: TextStyle(color: skinColor),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
