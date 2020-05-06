import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
   String terms;
  var response;
  _fetchDescription() async {
    response = await http.post(descriptionurl, body: {
      "desc": "shipping",
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        terms = items[0]["description"];
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
        terms == null
            ? Center(child: CircularProgressIndicator())
            :
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
              child: Column(
                children: <Widget>[
                  Text("Terms & Conditions",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Text(terms,
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
