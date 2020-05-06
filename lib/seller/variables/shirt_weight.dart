import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShirtWeight extends StatefulWidget {
  @override
  _ShirtWeightState createState() => _ShirtWeightState();
}

class _ShirtWeightState extends State<ShirtWeight> {
 String weight;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 210,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("Note: The shipping charges will be calculated according to the weight by UPS"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 15),
              child: TextFormField(
                onChanged: (value) {
                  weight = value;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                decoration: InputDecoration(
                  hintText: "weight in lbs",
                  prefixIcon: Icon(Icons.widgets),
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
                  if (weight == null) {
                    validation("Note", "Please enter the weight..", context);
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
      var response =
          await http.post(weighturl, body: {"id": userID, "weight": weight});
      print(response);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');
        validation('Success:', "weight has been added.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}