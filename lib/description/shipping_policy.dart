import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';

class ShippingPolicy extends StatefulWidget {
  @override
  _ShippingPolicyState createState() => _ShippingPolicyState();
}

class _ShippingPolicyState extends State<ShippingPolicy> {
  String shipping;
  var response;
  _fetchDescription() async {
    response = await http.post(descriptionurl, body: {
      "desc": "shipping",
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        shipping = items[0]["description"];
      });
      print(items);
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar().getAppBar(
          Icon(
            Icons.exit_to_app,
            color: transparent,
          ),
          "About Us",
          null),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Image.asset(
          "images/BG.png",
          fit: BoxFit.fill,
        ),
        shipping == null
            ? Center(child: CircularProgressIndicator())
            :
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
              child: Column(
                children: <Widget>[
                  Text("Shipping Policy",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Text(shipping,
                       style: TextStyle(fontSize: 12, )),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
