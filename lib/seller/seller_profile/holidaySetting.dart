import 'dart:convert';

import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/seller/seller_profile/addHoliday.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HolidaySetting extends StatefulWidget {
  @override
  _HolidaySettingState createState() => _HolidaySettingState();
}

class _HolidaySettingState extends State<HolidaySetting> {
  var userID, size;
  Future<List<HolidayModel>> _fetchHoliday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(holidayurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<HolidayModel> listOfUsers = items.map<HolidayModel>((json) {
        return HolidayModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future delete(id) async {
    await http
        .post(deleteProdFeaturesurl, body: {'id': id, "table": "holiday"});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HolidaySetting(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(
        Icon(Icons.add_box),
        "Holiday Detail",
        () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddHoliday()));
        },
      ),
      body: FutureBuilder<List<HolidayModel>>(
        future: _fetchHoliday(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Container(
              child: size == 0
                  ? Center(
                      child: Text("--No holidays yet--"),
                    )
                  : ListView(
                      children: snapshot.data
                          .map((holiday) => Card(
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
                                      Text(holiday.name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "from:",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              holiday.from,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "To:",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(width: 26),
                                            Text(
                                              holiday.to,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          OutlineButton(
                                            highlightColor: Colors.red.shade100,
                                            borderSide: BorderSide(
                                                color: Colors.red[700]),
                                            onPressed: () async {
                                              delete(holiday.holidaysid);
                                            },
                                            child: Text(
                                              "DELETE",
                                              style: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
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
