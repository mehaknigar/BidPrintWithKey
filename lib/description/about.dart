import 'dart:convert';

import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String about;
  var response;
  _fetchDescription() async {
    response = await http.post(descriptionurl, body: {
      "desc": "about",
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        about = items[0]["description"];
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
        about == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        "images/logoblack.png",
                        width: 200,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(about),
                                Text(
                                    "We are providing high quality and cost Effective networking solutions since 1994 and during this journey, we have managed to acquire a huge amount of trust and appreciation from the majority of our customers across the US who showed a great amount of confidence to buy high-quality products from us. All of our products come with a lifetime warranty so that your purchases with us are protected for the long haul."),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ]),
    );
  }
}
