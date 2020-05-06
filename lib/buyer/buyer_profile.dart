import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/chat/chat_lists.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerDashboard extends StatefulWidget {
  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  String name1, name2, email, number;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<void> _main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userID = prefs.getString('userID');
    var user = prefs.getString('user');
    // var name1 = prefs.getString('fname');
    // var name2 = prefs.getString('lname');
    // var numb = prefs.getString('number');
    print(email);
    print(userID);
    if (email == null && userID == null) {
      return null;
    } else {
      _firebaseMessaging.unsubscribeFromTopic('all');
      _firebaseMessaging.unsubscribeFromTopic('$userID-$user');
      _firebaseMessaging.unsubscribeFromTopic('$userID-$user-order');
      _firebaseMessaging.unsubscribeFromTopic('$userID-$user-chat');
      prefs.remove('email');
      prefs.remove('userID');
      prefs.remove("fname");
      prefs.remove("lname");
      prefs.remove("number");
      prefs.remove("user");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      print(email);
    }
  }

  _myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var e = prefs.getString('email');
    var n1 = prefs.getString('fname');
    var n2 = prefs.getString('lname');
    var numb = prefs.getString('number');
    setState(() {
      email = e;
      name1 = n1;
      name2 = n2;
      number = numb;
    });
  }

  @override
  void initState() {
    super.initState();
    _myPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(Icon(Icons.exit_to_app), "", () {
        _main();
      }),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ProfileButton(Icons.person, "EDIT ACCOUNT", Color(0xFF72a2cf),
                    () {
                  Navigator.pushNamed(context, "/editaccount");
                }),
                ProfileButton(Icons.lock, "EDIT PASSWORD", Color(0xFFcc9770),
                    () {
                  Navigator.pushNamed(context, "/password");
                }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                ProfileButton(
                    Icons.shopping_cart, "VIEW CART", Color(0xFFc46a9a), () {
                  Navigator.pushNamed(context, "/cart");
                }),
                ProfileButton(Icons.history, "ORDER HISTORY", Color(0xFF67bf8c),
                    () {
                  Navigator.pushNamed(context, "/orderHistory");
                }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                ProfileButton(Icons.home, "Add Address", Color(0xFF67bfbd), () {
                  Navigator.pushNamed(context, '/address');
                }),
                ProfileButton(
                    Icons.notifications, "Notiification", Color(0xFFba666a),
                    () {
                  Navigator.pushNamed(context, '/notification');
                }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                ProfileButton(Icons.chat, "Chat Detail", Color(0xFFab6ec4), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatListPage())));
                }),
                // ProfileButton(
                //     Icons.notifications, "Notiification", Color(0xFFba666a),
                //     () {
                //   Navigator.pushNamed(context, '/notification');
                // }),
              ],
            ),
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: InkWell(
          onTap: onPress,
          child: Container(
            width: 100,
            height: 100,
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
                  color: white,
                  size: 38,
                ),
                Text(
                  name,
                  style: TextStyle(color: white, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
