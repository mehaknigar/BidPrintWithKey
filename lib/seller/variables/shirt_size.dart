import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';

class ShirtSize extends StatefulWidget {
  @override
  _ShirtSizeState createState() => _ShirtSizeState();
}

class _ShirtSizeState extends State<ShirtSize> {
  String design, price;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RadioButtonGroup(
              labels: <String>[
                "XS",
                "S",
                "M",
                "L",
                'XS-XL',
                '2XL',
                '3XL',
                '4XL',
                '5XL',
                '6XL'
              ],
              onSelected: (String selected) {
                print(selected);
                if (selected == "XS") {
                  design = "XS";
                } else if (selected == "S") {
                  design = "S";
                } else if (selected == "M") {
                  design = "M";
                } else if (selected == "L") {
                  design = "L";
                } else if (selected == "XS-XL") {
                  design = "XS-XL";
                }else if (selected == "2XL") {
                  design = "2XL";
                }else if (selected == "3XL") {
                  design = "3XL";
                }else if (selected == "4XL") {
                  design = "4XL";
                }else if (selected == "5XL") {
                  design = "5XL";
                }else if (selected == "6XL") {
                  design = "6XL";
                }
                print(design);
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                price = value;
              },
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              decoration: InputDecoration(
                hintText: "Price",
                prefixIcon: Icon(Icons.attach_money),
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: themeColor,
              onPressed: () {
                if (design == null) {
                  validation("Note", "Please Select an option", context);
                } else if (price == null) {
                  validation("Note", "Please enter the price", context);
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
      var response = await http.post(shirtSizeurl,
          body: {"id": userID, "design": design, "price": price});
      print(response);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');
        validation('Success:', "T-Shirt Size has been updated.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}