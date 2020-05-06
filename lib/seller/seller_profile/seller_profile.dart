import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/chat/chat_lists.dart';
import 'package:bidprint/seller/seller_profile/rating.dart';
import 'package:bidprint/seller/seller_profile/seller_edit_address.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:bidprint/variables/url.dart';

class SellerProfile extends StatefulWidget {
  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile>
    with TickerProviderStateMixin {
  double screenSize;
  double screenRatio;

  List<Tab> tabList = List();
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String email = "", first = "", last = "", number = "";
  Future<void> _main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userID = prefs.getString('userID');
    print(email);
    print(userID);
    if (email == null && userID == null) {
      return null;
    } else {
      prefs.remove('email');
      prefs.remove('userID');
      prefs.remove("fname");
      prefs.remove("lname");
      prefs.remove("number");
      prefs.remove("user");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String e = prefs.getString("email");
    String f = prefs.getString('fname');
    String l = prefs.getString('lname');
    String n = prefs.getString('number');
    setState(() {
      email = e;
      first = f;
      last = l;
      number = n;
    });
  }

  String rating, reviews, company, address, city, post, country, zone;
  var response;
  _fetchRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    response = await http.post(avrgRatingurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        rating = items[0]["rating"].toStringAsFixed(2);
        reviews = items[0]["review"].toString();
        company = items[0]["company_name"].toString();
        address = items[0]["address"].toString();
        city = items[0]["city"].toString();
        post = items[0]["postcode"].toString();
        country = items[0]["country_name"].toString();
        zone = items[0]["zone_name"].toString();
      });
      print(items);
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    getValue();
    _fetchRating();
  }

  double gap;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    gap = screenSize.height * 0.45;
    screenRatio = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: white,
        appBar: TopBar().getAppBar(Icon(Icons.exit_to_app), "", () {
          _main();
        }),
        body: response == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Stack(//alignment: Alignment.center,
                      children: <Widget>[
                    Container(
                      child: Image.asset(
                        "images/bgg.jpg",
                        fit: BoxFit.fill,
                        width: screenSize.width,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RaisedButton.icon(
                            color: themebottom,
                            onPressed: () {
                              Navigator.pushNamed(context, "/totalsellerPay");
                              
                            },
                            icon: Icon(
                              Icons.monetization_on,
                              color: Colors.grey[600],
                            ),
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                "Payments",
                                style: TextStyle(color: themeColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0, bottom: 10),
                      child: Column(children: <Widget>[
                        Text(first + " " + last, style: title22),
                        SizedBox(height: 5),
                        Text(email, style: title33),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$rating "),
                            Text("\($reviews Reviews\)"),
                            SizedBox(width: 10),
                            SmoothStarRating(
                                allowHalfRating: true,
                                starCount: 5,
                                rating: double.parse(rating),
                                size: 20.0,
                                color: Colors.yellow[900],
                                borderColor: Colors.yellow[900],
                                spacing: 0.0),
                          ],
                        ),
                      ]),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        ProfileButton(
                            Icons.person, "EDIT ACCOUNT", Color(0xFFd6b4d2),
                            () {
                          Navigator.pushNamed(context, "/editaccount");
                        }),
                        ProfileButton(
                            Icons.lock, "EDIT PASSWORD", Color(0xFFd6d4b4), () {
                          Navigator.pushNamed(context, '/password');
                        }),
                        ProfileButton(
                            Icons.business, "EDIT ADDRESS", Color(0xFFd6b4b4),
                            () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SellerEditAddress(
                                      company,
                                      address,
                                      city,
                                      post,
                                      country,
                                      zone))));
                        })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        ProfileButton(Icons.notifications, "Notification",
                            Color(0xFFd6b4b4), () {
                          Navigator.pushNamed(context, "/notification");
                        }),
                        ProfileButton(Icons.view_agenda, "VIEW FEATURES",
                            Color(0xFFbcd6b4), () {
                          Navigator.pushNamed(context, '/addproductfeatures');
                        }),
                        ProfileButton(
                            Icons.history, "ORDER HISTORY", Color(0xFFb4d6d3),
                            () {
                          Navigator.pushNamed(context, "/sellerorderHistory");
                        }),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      ProfileButton(
                          Icons.star, "View Reviews", Color(0xFFc9bf9d), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    SellerRating(rating, reviews))));
                      }),
                      ProfileButton(
                          Icons.settings, "Holiday Setting", Color(0xFFa896a8),
                          () {
                        Navigator.pushNamed(context, '/holiday');
                      }),
                      ProfileButton(
                          Icons.chat, "Chat Detail", Color(0xFFab6ec4), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ChatListPage())));
                      }),
                    ],
                  ),
                ],
              ));
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icn;
  final String name;
  final Color clr;
  final Function onPress;
  ProfileButton(this.icn, this.name, this.clr, this.onPress);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: onPress,
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topLeft,
                    colors: [
                      clr,
                      Color(0xFFffffff),
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  icn,
                  color: Colors.grey[600],
                  size: 26,
                ),
                Text(
                  name,
                  style: TextStyle(color: themeColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
