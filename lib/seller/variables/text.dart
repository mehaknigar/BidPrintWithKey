import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/url.dart';

class CustomText extends StatefulWidget {
  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  String word, price;
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
                          child:
                              Text("Enter the price for a single word e.i a"),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: themeColor,
                onPressed: () {
                  if (word == null) {
                    validation("Note", "Please select an option..", context);
                  } else if (word == "Yes") {
                    if (price == null) {
                      validation("Note", "Please enter the price..", context);
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
            )
          ],
        ),
      ),
    );
  }

  bool visible = false;
  addTShirtColor() async {
    setState(() {
      visible = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    if (userID == null) {
      return null;
    } else {
      print("$word $price");
      var response = await http.post(texturl, body: {
        "id": userID,
        "word": word,
        "price": word == 'Yes' ? price : ''
      });
      print(response);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');

        validation('Success:', "Text-/word price has been updated.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}
