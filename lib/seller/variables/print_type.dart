import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/url.dart';

class PrintType extends StatefulWidget {
  @override
  _PrintTypeState createState() => _PrintTypeState();
}

class _PrintTypeState extends State<PrintType> {
  String screen, embroid;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Do you offer Custom Text?",
                  softWrap: true,
                )),
            SizedBox(height: 10),
            CheckboxListTile(
                title: Text("Screen Printing"),
                value: _isChecked1,
                onChanged: (val) {
                  setState(() {
                    _isChecked1 = val;
                    if (val == true) {
                      setState(() {
                        screen = "Screen Printing";
                      });
                    }
                  });
                }),
            CheckboxListTile(
                title: Text("Embroidery"),
                value: _isChecked2,
                onChanged: (val) {
                  setState(() {
                    _isChecked2 = val;
                    if (val == true) {
                      setState(() {
                        embroid = "Embroidery";
                      });
                    }
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: themeColor,
                onPressed: () {
                  addTShirtPrintType();

                  print("$screen $embroid");
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: skinColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool visible = false;
  addTShirtPrintType() async {
    setState(() {
      visible = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    if (userID == null) {
      return null;
    } else {
      print("$screen $embroid");
      var response = await http.post(printTypeurl, body: {
        "id": userID,
        "screen": screen == null ? '' : screen,
        "embroid": embroid == null ? '' : embroid
      });
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');

        validation('Success:', "Print type has been updated.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}
