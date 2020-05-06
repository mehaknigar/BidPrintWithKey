import 'package:bidprint/account/login.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopBar {
  getAppBar(Widget name, String title, Function onPress) {
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: AppBar(
        // titleSpacing: 1,
        centerTitle: true,
        backgroundColor: themebottom,

        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: onPress,
            icon: name,
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String email, user;
  String user1 = "buyer";
  String user2 = "seller";
  _myPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = prefs.getString('email');
    var u = prefs.getString('user');
    if (m == null) {
      setState(() {
        email = m;
        user = u;
      });
    } else {
      setState(() {
        email = m;
        user = u;
      });
    }
    print(m);
  }

  _main() {
    if (email == null) {
      //show a dialog not logged in do you want to login as  a buyer or seller than go to login page
      doubleQueDialog(
          "",
          "Do you want to Buy or Sell?",
          'Buy',
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Login(user1))));
          },
          "Sell",
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Login(user2))));
          },
          context);
    } else {
      if (user == "buyer") {
        Navigator.pushNamed(context, "/buyer");
      } else {
        Navigator.pushNamed(context, "/seller");
      }
      print(user);
    }
  }

  @override
  void initState() {
    super.initState();
    _myPref();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset("images/BG.png", fit: BoxFit.cover),
          ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
                child: Image.asset("images/logoblack.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset("images/Rectangle1.png"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/about");
                },
                title: Text("About", style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/About.png",
                  width: 45,
                ),
              ),
              ListTile(
                onTap: () {
                  _main();
                },
                title:
                    Text("User Account", style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/Account.png",
                  width: 45,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/shipPolicy");
                },
                title: Text("Shipping & Return Policy",
                    style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/Shipping-And-Return-Policy.png",
                  width: 45,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/terms");
                },
                title: Text("Terms & Conditions",
                    style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/Terms-and-Conditions.png",
                  width: 45,
                ),
              ),
              ListTile(
                onTap: () {
                  klaunchURL();
                },
                title: Text("Reviews", style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/review.png",
                  width: 45,
                ),
              ),
              ListTile(
                onTap: () {
                  Share.share(
                      'Custom T-Shirt Printing https://play.google.com/store/apps/details?id=com.skylite.adomtv',
                      subject:
                          'The app provide you the facility to buy and sell T-Shirts!');
                },
                title: Text("Share", style: TextStyle(color: themebutton)),
                leading: Image.asset(
                  "images/Share.png",
                  width: 45,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
