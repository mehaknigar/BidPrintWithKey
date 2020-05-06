import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/seller/seller_profile/holidaySetting.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddHoliday extends StatefulWidget {
  @override
  _AddHolidayState createState() => _AddHolidayState();
}

class _AddHolidayState extends State<AddHoliday> {
  var from, to;

  void callDateFromPicker() async {
    var orderFrom = await getFromDate();
    setState(() {
      from = orderFrom;
    });
  }

  void callDateToPicker() async {
    var orderTo = await getToDate();
    setState(() {
      to = orderTo;
    });
  }

  Future<DateTime> getFromDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  Future<DateTime> getToDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  bool _saving = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  void _submit() async {
    if (from == null || to == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Error",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Please select a valid date',
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _saving = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getString("userID");
      var response = await http.post(addholidayurl, body: {
        "id": userID,
        "name": name.text.toString(),
        "from": from.toString(),
        "to": to.toString(),
      });
      setState(() {
        _saving = false;
      });
      print(response);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HolidaySetting(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(
          Icon(
            Icons.exit_to_app,
            color: transparent,
          ),
          "Add Holidays",
          () {}),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Holiday Title',
                      ),
                      controller: name,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter Holiday Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Select Date",
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "From:  ",
                        ),
                        IconButton(
                          onPressed: callDateFromPicker,
                          color: Colors.blueAccent,
                          icon: Icon(Icons.calendar_today),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        from != null
                            ? Text(
                                "$from",
                              )
                            : SizedBox(),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "To:  ",
                        ),
                        IconButton(
                          onPressed: callDateToPicker,
                          color: Colors.blueAccent,
                          icon: Icon(Icons.calendar_today),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        to != null
                            ? Text(
                                "$to",
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: AccountButton(
                            () => setState(() {
                                  if (formKey.currentState.validate()) {
                                    _submit();
                                  }
                                }),
                            'Submit',
                            themeColor),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        inAsyncCall: _saving,
      ),
    );
  }
}
