import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalSellerPayments extends StatefulWidget {
  @override
  _TotalSellerPaymentsState createState() => _TotalSellerPaymentsState();
}

class _TotalSellerPaymentsState extends State<TotalSellerPayments> {
  var userID, size;
  var response;
  Future<List<SellerPaymentsModule>> _fetchHoliday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    response = await http.post(sellerPaymentsurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        total = items[0]["total"].toStringAsFixed(2);
        email = items[0]["email"].toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHoliday();
  }

  String total, email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(
        Icon(Icons.dashboard),
        "Payments Detail",
        () {
          Navigator.pushNamed(context, "/sellerPay");
        },
      ),
      body: response == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: size == 0
                  ? Center(
                      child: Text("--No Payments yet--"),
                    )
                  : Column(
                      children: <Widget>[
                        Image.asset("images/paypal.jpg"),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15, vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Payer Email:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  email,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15, vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Currency Code:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "USD",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15, vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Total Amount:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "\$" + total,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
