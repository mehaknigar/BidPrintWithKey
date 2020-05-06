import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerPayments extends StatefulWidget {
  @override
  _SellerPaymentsState createState() => _SellerPaymentsState();
}

class _SellerPaymentsState extends State<SellerPayments> {
  var userID, size;
  Future<List<SellerPaymentsModule>> _fetchHoliday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(sellerPaymentsurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<SellerPaymentsModule> listOfUsers =
          items.map<SellerPaymentsModule>((json) {
        return SellerPaymentsModule.fromJson(json);
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
      appBar: TopBar().getAppBar(
        Icon(Icons.add_box, color: transparent),
        "Payments Detail",
        null,
      ),
      body: FutureBuilder<List<SellerPaymentsModule>>(
        future: _fetchHoliday(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Container(
              child: size == 0
                  ? Center(
                      child: Text("--No Payments yet--"),
                    )
                  : ListView(
                      children: snapshot.data
                          .map((pay) => Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border(
                                      top: BorderSide(
                                          width: 2.0, color: themeshirtbg),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border(),
                                        ),
                                        child: Text(pay.txn,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Payer Email:",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(width: 12),
                                            Flexible(
                                              child: Text(
                                                pay.email,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Currency Code:",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                               pay.currency,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Total Amount:",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "\$" + pay.payment,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              pay.status,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList()));
        },
      ),
    );
  }
}
