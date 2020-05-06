import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account/login.dart';
import 'chat/chat_screen.dart';

bool mail = false;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String user1 = "buyer";
  String user2 = "seller";

  Future<void> _logout(user) async {
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
      print(email);
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Login(user))));
    }
  }

  _myPreferences() async {
    if (user == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Login(user2))));
    } else {
      if (user == "buyer") {
        print(user);
        doubleQueDialog(
            "Note:",
            "You are signed in as a buyer, Do you want to Sign Out?",
            'NO',
            () {
              Navigator.of(context).pop(false);
            },
            "Yes",
            () {
              _logout(user2);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: ((context) => Login(user2))));
            },
            context);
      } else {
        Navigator.pushNamed(context, "/addproductfeatures");
      }
    }
  }

  _myPreferences2() async {
    if (user == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Login(user1))));
    } else {
      if (user == "seller") {
        print(user);
        doubleQueDialog(
            "Note:",
            "You are signed in as a seller, Do you want to Sign Out?",
            'NO',
            () {
              Navigator.of(context).pop(false);
            },
            "Yes",
            () {
              _logout(user1);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: ((context) => Login(user1))));
            },
            context);
      } else {
        Navigator.pushNamed(context, "/buy");
      }
    }
  }

  String email, user;
  _myPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = prefs.getString('email');
    var u = prefs.getString('user');
    if (m == null) {
      setState(() {
        mail = false;
        email = m;
        user = u;
      });
    } else {
      setState(() {
        mail = true;
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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _navigateToItemDetail(Widget page) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => page,
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    _myPref();

    if (mail) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          //_showItemDialog(message);
          final notification = message['data'];
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");

          final notification = message['data'];

          if (notification['for'] == 'chat') {
            _navigateToItemDetail(
              ChatScreen(
                userEmail: notification['targetEmail'],
                userID: notification['targetID'],
                userType: notification['targetUserType'],
                chatID: notification['chatID'],
                targetEmail: notification['senderEmail'],
                targetID: notification['senderID'],
                targetUserType: notification['senderUserType'],
              ),
            );
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");

          final notification = message['data'];

          if (notification['for'] == 'chat') {
            _navigateToItemDetail(
              ChatScreen(
                userEmail: notification['targetEmail'],
                userID: notification['targetID'],
                userType: notification['targetUserType'],
                chatID: notification['chatID'],
                targetEmail: notification['senderEmail'],
                targetID: notification['senderID'],
                targetUserType: notification['senderUserType'],
              ),
            );
          }
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => doubleQueDialog(
          "Are you sure!",
          "You want to exit from the app?",
          'NO',
          () {
            Navigator.of(context).pop(false);
          },
          "Yes",
          () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          context),
      child: Scaffold(
        appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
        drawer: MyDrawer(),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    "images/Tshirt.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.white,
                  elevation: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _myPreferences2();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            "images/customer.png",
                            height: 60,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "images/line.png",
                          height: 80,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _myPreferences();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            "images/supplier.png",
                            height: 55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: OutlineButton(
                    child: mail == false
                        ? Text(
                            "Sign In",
                            style: TextStyle(
                                color: themebutton,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "View Profile",
                            style: TextStyle(
                                color: themebutton,
                                fontWeight: FontWeight.bold),
                          ),
                    onPressed: () {
                      _main();
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    borderSide: BorderSide(color: themebutton),
                  )),
            ],
          ),
        ]),
      ),
    );
  }
}
