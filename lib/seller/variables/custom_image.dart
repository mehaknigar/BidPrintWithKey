import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomImage extends StatefulWidget {
  @override
  _CustomImageState createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  String word, price;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Do you offer Custom Images?"),
            ),
            RadioButtonGroup(
                labels: <String>[
                  "Yes",
                  "No",
                ],
                onSelected: (String selected) {
                  print(selected);
                  if (selected == "Yes") {
                    setState(() {
                      word = "Yes";
                    });
                  } else {
                    setState(() {
                      word = "No";
                    });
                  }
                  print(word);
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: word == "Yes"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Enter the Price for the image"),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            price = value;
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                          decoration: InputDecoration(
                            hintText: "Price",
                            prefixIcon: Icon(Icons.monetization_on),
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: themeColor,
                    onPressed: () {
                      if (word == null) {
                        validation(
                            "Note", "Please select an option..", context);
                      } else if (word == "Yes") {
                        if (price == null) {
                          validation(
                              "Note", "Please enter the price..", context);
                        } else {
                          addTShirtColor();
                        }
                      } else {
                        addTShirtColor();
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: skinColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool visible = false;
  var response;
  addTShirtColor() async {
    setState(() {
      visible = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    if (userID == null) {
      return null;
    } else {
      if (word == "Yes") {
        response = await http.post(customImageurl,
            body: {"id": userID, "word": word, "price": price});
      } else {
        response = await http.post(customImageurl,
            body: {"id": userID, "word": word, "price": ''});
      }

      print(response);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');
        validation('Success:', "Data has been updated.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}
