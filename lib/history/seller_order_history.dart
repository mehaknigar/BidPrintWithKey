import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/history/seller_order_history_extend.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:bidprint/variables/url.dart';

class SellerOrderHistory extends StatefulWidget {
  @override
  _SellerOrderHistoryState createState() => _SellerOrderHistoryState();
}

class _SellerOrderHistoryState extends State<SellerOrderHistory> {
  int size, size2;
  var userID;
  Future<List<OrderHist>> _fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var user = prefs.getString('user');
    var response =
        await http.post(orderHistoryurl, body: {"id": userID, "user": user});
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<OrderHist> listOfUsers = items.map<OrderHist>((json) {
        return OrderHist.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  // String _mySelection;
  // Future<List<OrderStatus>> _fetchStatus() async {
  //   var response = await http.post(orderStatusurl);
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     List<OrderStatus> listOfUsers = items.map<OrderStatus>((json) {
  //       return OrderStatus.fromJson(json);
  //     }).toList();
  //     size2 = listOfUsers.length;
  //     return listOfUsers;
  //   } else {
  //     throw Exception('Failed to load internet');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: FutureBuilder<List<OrderHist>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (size == 0) {
            return Center(
                child: Text(
              "--No History Found--",
              style: TextStyle(color: Colors.grey),
            ));
          } else
            return Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  color: Colors.white, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(size.toString() + " Orders..",
                        textAlign: TextAlign.start, style: heading2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: ListView(
                      children: snapshot.data
                          .map(
                            (order) => Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border(
                                        top: BorderSide(
                                            width: 2.0, color: themeshirtbg),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "\#00" + order.orderId,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          SellerOrderHistoryExtend(
                                                              order.orderId,order.customerId,
                                                              order.firstname,
                                                              order.lastname,order.email,
                                                              order.date,
                                                              order.printType,
                                                              order.textType,
                                                              order.shirtStyle,
                                                              order.track,
                                                              order.address,
                                                              order.country,
                                                              order.city,
                                                              order.zone,
                                                              order.shirtColor,
                                                              order.size,
                                                              order.quantity,
                                                              order.text,
                                                              order.textColor,
                                                              order.font,
                                                              order.designType,
                                                              order.image,
                                                              order.cost,
                                                              order.totalCost,
                                                              order.sub,
                                                              order .shipping,order.sellerId,order.sellerf,order.sellerl,order.sellerEm
                                                            ,order.sellerNumb,order.shape,order.ss))));
                                            },
                                            icon: Icon(
                                                Icons.keyboard_arrow_right),
                                            color: Colors.grey[800])
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Your Name:  ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[500]),
                                        ),
                                        Text(
                                            order.firstname +
                                                " " +
                                                order.lastname,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Order Date:  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500]),
                                        ),
                                        Text(order.date,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Status:  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500]),
                                        ),
                                        Container(
                                          child: order.track == "Complete"
                                              ? Text(order.track,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green[600]))
                                              : Text(order.track,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red[600])),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Quantity:  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500]),
                                        ),
                                        Text(order.quantity,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Total Amount : ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500]),
                                        ),
                                        Text("\$" + order.totalCost,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      child: order.rate == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0),
                                                      child: order.track ==
                                                              "Complete"
                                                          ? Text(
                                                              "Waiting for Reviews..",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue))
                                                          : null),
                                                  // FutureBuilder<List<OrderStatus>>(
                                                  //       future: _fetchStatus(),
                                                  //       builder: (context, snapshot) {
                                                  //         if (!snapshot.hasData)
                                                  //           return Container(
                                                  //               width: 60,
                                                  //               child: DropdownButton<String>(
                                                  //                 isExpanded: true,
                                                  //                 isDense: true,
                                                  //                 disabledHint: Text(
                                                  //                   "Select",
                                                  //                   style:
                                                  //                       TextStyle(fontSize: 16),
                                                  //                 ),
                                                  //                 items: null,
                                                  //                 onChanged: (String value) {},
                                                  //               ));
                                                  //         if (size2 == 0) {
                                                  //           return Center(
                                                  //               child: Text(
                                                  //             "",
                                                  //             style:
                                                  //                 TextStyle(color: Colors.grey),
                                                  //           ));
                                                  //         } else
                                                  //           return DropdownButton<String>(
                                                  //               isDense: true,
                                                  //               hint: Text(
                                                  //                 "Select",
                                                  //                 style:
                                                  //                     TextStyle(fontSize: 16),
                                                  //               ),
                                                  //               value: _mySelection,
                                                  //               onChanged: (String newValue) {
                                                  //                 setState(() {
                                                  //                   _mySelection = newValue;
                                                  //                 });
                                                  //                 print(_mySelection);
                                                  //               },
                                                  //               items: snapshot.data
                                                  //                   .map((c) =>
                                                  //                       DropdownMenuItem<
                                                  //                           String>(
                                                  //                         value: c.statusid,
                                                  //                         child: OutlineButton(
                                                  //                           onPressed: (){},
                                                  //                        child: Text( c.name,
                                                  //                           style: TextStyle(
                                                  //                               fontSize: 16),)
                                                  //                         ),
                                                  //                       ))
                                                  //                   .toList());
                                                  //       }),
                                                  // ),
                                                ],
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(order.rate + "  "),
                                                SmoothStarRating(
                                                    allowHalfRating: true,
                                                    starCount: 5,
                                                    rating: double.parse(
                                                        order.rate),
                                                    size: 22.0,
                                                    color: Colors.yellow[700],
                                                    borderColor:
                                                        Colors.yellow[600],
                                                    spacing: 0.0),
                                              ],
                                            )),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
