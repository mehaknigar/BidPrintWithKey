import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int size;
  var userID, user;
  Future<List<ViewNotification>> _fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('email');
    user = prefs.getString('user');
    var response =
        await http.post(notificationurl, body: {"email": userID, "user": user});
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ViewNotification> listOfUsers = items.map<ViewNotification>((json) {
        return ViewNotification.fromJson(json);
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
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: FutureBuilder<List<ViewNotification>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (size == 0) {
            return Center(
                child: Text(
              "--No Notifications Found--",
              style: TextStyle(color: Colors.grey),
            ));
          } else
            return Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.white, //(0xFF2ecc71),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text("Notifications",
                        textAlign: TextAlign.start, style: heading2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    child: ListView(
                      children: snapshot.data
                          .map((notification) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: white,
                                      border: Border(
                                        top: BorderSide(
                                            width: 2.0, color: themeshirtbg),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            notification.detail,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(notification.date,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
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
