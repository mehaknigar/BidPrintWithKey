import 'package:bidprint/account/login.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/shirt_preview/preview.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyTShirt extends StatefulWidget {
  @override
  _BuyTShirtState createState() => _BuyTShirtState();
}

class _BuyTShirtState extends State<BuyTShirt> {
  String dropdownShirtColor, dropdownShirtSize, dropdownShirtStyle;
  String design, printtype;
  int quantity = 001;
  String user;

  _prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("user");
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => Login("buyer"))));
    } else if (user == "buyer") {
      Navigator.pushNamed(context, "/cart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar().getAppBar(
          Icon(Icons.shopping_cart), "Select Features".toUpperCase(), () {
        _prefs();
      }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("T-Shirt Color:", style: heading),
                      SizedBox(
                        width: 50,
                      ),
                      DropdownButton<String>(
                        value: dropdownShirtColor,
                        hint: Text("--SELECT--",
                            style: TextStyle(color: themebutton)),
                        underline: Container(
                          height: 2,
                          color: themebutton,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownShirtColor = newValue;
                            print(dropdownShirtColor);
                          });
                        },
                        items: <String>[
                          'Grey',
                          'Black',
                          'White',
                          'Light-Blue',
                          'Blue',
                          'Purple',
                          'Orange',
                          'Red',
                          'Pink',
                          'Yellow',
                          'Light-Green',
                          'Green',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Quantity",
                              style: heading,
                            ),
                            SizedBox(width: 25),
                            QuantityButton("-", () {
                              setState(() {
                                if (quantity != 1) {
                                  quantity--;
                                }
                              });
                            }),
                            RawMaterialButton(
                              onPressed: null,
                              constraints: BoxConstraints.tightFor(
                                  width: 54, height: 26),
                              fillColor: Colors.grey[300],
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[600]),
                              ),
                            ),
                            QuantityButton("+", () {
                              setState(() {
                                quantity++;
                              });
                              print(quantity);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("T-Shirt Size:", style: heading),
                      SizedBox(
                        width: 50,
                      ),
                      DropdownButton<String>(
                        value: dropdownShirtSize,
                        hint: Text("--SELECT--",
                            style: TextStyle(color: themebutton)),
                        underline: Container(
                          height: 2,
                          color: themebutton,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownShirtSize = newValue;
                            print(dropdownShirtSize);
                          });
                        },
                        items: <String>[
                          'XS',
                          'S',
                          'M',
                          'L',
                          'XS-XL',
                          '2XL',
                          '3XL',
                          '4XL',
                          '5XL',
                          '6XL'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Print Type:", style: heading),
                    RadioButtonGroup(
                        labels: <String>["Screen Printing", "Embroidery"],
                        onSelected: (String selected) {
                          if (selected == "Embroidery") {
                            printtype = "Embroidery";
                          } else {
                            printtype = "Screen Printing";
                          }
                          print(printtype);
                        }),
                  ],
                ),
              )),
              Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Shirt Style:", style: heading),
                    SizedBox(
                      width: 50,
                    ),
                    DropdownButton<String>(
                      hint: Text("--SELECT--",
                          style: TextStyle(color: themebutton)),
                      underline: Container(
                        height: 2,
                        color: themebutton,
                      ),
                      value: dropdownShirtStyle,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownShirtStyle = newValue;
                        });
                      },
                      items: <String>[
                        'Tear Away Tag',
                        'Short Sleeve',
                        'Without Pocket',
                        'V-Neck ',
                        'Long Sleeve',
                        'Tag Free',
                        'Sleeveless',
                        'V-Neck',
                        'With Pocket',
                        'With Hood',
                        'Without Hood',
                        'Raglan Sleeve',
                        '3/4 Sleeve',
                        'Racerback (17)',
                        'Pigment-Dyed'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )),
              Card(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Design Type:", style: heading),
                    RadioButtonGroup(
                        labels: <String>[
                          "Front Side",
                          "Back Side",
                          "Both - Front and Back",
                          "Sleeves",
                          "Both Sleeves"
                        ],
                        onSelected: (String selected) {
                          if (selected == "Front Side") {
                            design = "Front Side";
                          } else if (selected == "Back Side") {
                            design = "Back Side";
                          } else {
                            design = "Both";
                          }
                          print(design);
                        }),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: FlatButton(
                onPressed: null,
                child: Text(""),
              ),
            ),
            Expanded(
              flex: 6,
              child: RaisedButton(
                color: themeColor,
                onPressed: () {
                  if (dropdownShirtColor == null ||
                      design == null ||
                      quantity == null ||
                      dropdownShirtSize == null ||
                      dropdownShirtStyle == null ||
                      printtype == null) {
                    validation("Note", "Please fill all the fields", context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ShirtPreview(
                                dropdownShirtColor,
                                design,
                                dropdownShirtSize,
                                dropdownShirtStyle,
                                printtype,
                                quantity))));
                    print("$dropdownShirtColor  $dropdownShirtSize ");
                    print(" $quantity  $design");
                  }
                },
                child: Text(
                  "Continue To Design Shirt",
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
