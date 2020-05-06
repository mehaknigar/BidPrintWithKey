import 'dart:convert';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidprint/variables/url.dart';
import 'package:http/http.dart' as http;

class TextColor extends StatefulWidget {
  @override
  _TextColorState createState() => _TextColorState();
}

class _TextColorState extends State<TextColor> {
  bool _red = false;
  bool _blue = false;
  bool _orange = false;
  bool _green = false;
  bool _lightGreen = false;
  bool _yellow = false;
  bool _pink = false;
  bool _black = false;
  bool _grey = false;
  bool _white = false;
  bool _lightBlue = false;
  bool _purple = false;
  var holder_1 = [];
  var holder_2 = [];
  void onChanged(String title, bool value) {
    setState(() {
      switch (title) {
        case "Red":
          _red = value;
          if (value == true && holder_1.contains('Red') != true) {
            holder_1.add('Red');
            print(holder_1);
          } else if (value == false && holder_1.contains('Red') == true) {
            holder_1.remove('Red');
            print(holder_1);
          }
          break;
        case "Blue":
          _blue = value;
          if (value == true && holder_1.contains('Blue') != true) {
            holder_1.add('Blue');
            print(holder_1);
          } else if (value == false && holder_1.contains('Blue') == true) {
            holder_1.remove('Blue');
            print(holder_1);
          }
          break;
        case "Orange":
          _orange = value;
          if (value == true && holder_1.contains('Orange') != true) {
            holder_1.add('Orange');
            print(holder_1);
          } else if (value == false && holder_1.contains('Orange') == true) {
            holder_1.remove('Orange');
            print(holder_1);
          }
          break;
        case "Green":
          _green = value;
          if (value == true && holder_1.contains('Green') != true) {
            holder_1.add('Green');
            print(holder_1);
          } else if (value == false && holder_1.contains('Green') == true) {
            holder_1.remove('Green');
            print(holder_1);
          }
          break;
        case "Light-Green":
          _lightGreen = value;
          if (value == true && holder_1.contains('Light-Green') != true) {
            holder_1.add('Light-Green');
            print(holder_1);
          } else if (value == false &&
              holder_1.contains('Light-Green') == true) {
            holder_1.remove('Light-Green');
            print(holder_1);
          }
          break;
        case "Yellow":
          _yellow = value;
          if (value == true && holder_1.contains('Yellow') != true) {
            holder_1.add('Yellow');
            print(holder_1);
          } else if (value == false && holder_1.contains('Yellow') == true) {
            holder_1.remove('Yellow');
            print(holder_1);
          }
          break;
        case "Pink":
          _pink = value;
          if (value == true && holder_1.contains('Pink') != true) {
            holder_1.add('Pink');
            print(holder_1);
          } else if (value == false && holder_1.contains('Pink') == true) {
            holder_1.remove('Pink');
            print(holder_1);
          }
          break;
        case "Black":
          _black = value;
          if (value == true && holder_1.contains('Black') != true) {
            holder_1.add('Black');
            print(holder_1);
          } else if (value == false && holder_1.contains('Black') == true) {
            holder_1.remove('Black');
            print(holder_1);
          }
          break;
        case "Grey":
          _grey = value;
          if (value == true && holder_1.contains('Grey') != true) {
            holder_1.add('Grey');
            print(holder_1);
          } else if (value == false && holder_1.contains('Grey') == true) {
            holder_1.remove('Grey');
            print(holder_1);
          }
          break;
        case "White":
          _white = value;
          if (value == true && holder_1.contains('White') != true) {
            holder_1.add('White');
            print(holder_1);
          } else if (value == false && holder_1.contains('White') == true) {
            holder_1.remove('White');
            print(holder_1);
          }
          break;
        case "Light-Blue":
          _lightBlue = value;
          if (value == true && holder_1.contains('Light-Blue') != true) {
            holder_1.add('Light-Blue');
            print(holder_1);
          } else if (value == false &&
              holder_1.contains('Light-Blue') == true) {
            holder_1.remove('Light-Blue');
            print(holder_1);
          }
          break;
        case "Purple":
          _purple = value;
          if (value == true && holder_1.contains('Purple') != true) {
            holder_1.add('Purple');
            print(holder_1);
          } else if (value == false && holder_1.contains('Purple') == true) {
            holder_1.remove('Purple');
            print(holder_1);
          }
          break;
      }
    });
  }

  _fetchGetColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString("userID");
    var response = await http.post(getColorurl, body: {
      "id": userID,
      "type": "text",
    });
    if (response.statusCode == 200) {
      final sm = json.decode(response.body);
      if (sm.length > 0) {
        setState(() {
          holder_2 = sm;
          holder_1 = holder_2;
        });
      } else {
        return null;
      }
      print(holder_2);
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGetColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Table(
          border: TableBorder.all(color: Colors.grey[300]),
          children: [
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Grey') ? true : _grey,
                    activeColor: Colors.grey,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.grey),
                    onChanged: (bool value) {
                      onChanged('Grey', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Black') ? true : _black,
                    activeColor: Colors.black,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.black),
                    onChanged: (bool value) {
                      onChanged('Black', value);
                    }),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('White') ? true : _white,
                    activeColor: Colors.white,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.white),
                    onChanged: (bool value) {
                      onChanged('White', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Light-Blue') ? true : _lightBlue,
                    activeColor: Colors.lightBlue,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.lightBlue),
                    onChanged: (bool value) {
                      onChanged('Light-Blue', value);
                    }),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Blue') ? true : _blue,
                    activeColor: Colors.blue[900],
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.blue[900]),
                    onChanged: (bool value) {
                      onChanged('Blue', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Purple') ? true : _purple,
                    activeColor: Colors.purple,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.purple),
                    onChanged: (bool value) {
                      onChanged('Purple', value);
                    }),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Orange') ? true : _orange,
                    activeColor: Colors.orange,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.orange),
                    onChanged: (bool value) {
                      onChanged('Orange', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Red') ? true : _red,
                    activeColor: Colors.red,
                    secondary: Icon(Icons.format_color_fill, color: Colors.red),
                    onChanged: (bool value) {
                      onChanged('Red', value);
                    }),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Pink') ? true : _pink,
                    activeColor: Colors.pink[300],
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.pink[300]),
                    onChanged: (bool value) {
                      onChanged('Pink', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Yellow') ? true : _yellow,
                    activeColor: Colors.yellow,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.yellow),
                    onChanged: (bool value) {
                      onChanged('Yellow', value);
                    }),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: CheckboxListTile(
                    value:
                        holder_2.contains('Light-Green') ? true : _lightGreen,
                    activeColor: Colors.green,
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.green),
                    onChanged: (bool value) {
                      onChanged('Light-Green', value);
                    }),
              ),
              TableCell(
                child: CheckboxListTile(
                    value: holder_2.contains('Green') ? true : _green,
                    activeColor: Colors.green[900],
                    secondary:
                        Icon(Icons.format_color_fill, color: Colors.green[900]),
                    onChanged: (bool value) {
                      onChanged('Green', value);
                    }),
              ),
            ]),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: themeColor,
            onPressed: () {
              if (holder_1 != null) {
                addTShirtColor();
              } else {
                validation("Note",
                    "Something went wrong, please try again later", context);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: skinColor),
            ),
          ),
        ),
      ],
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
      var response = await http.post(sellerColorurl,
          body: {"id": userID, "colors": holder_1.toString(), "type": "text"});
      print(response);
      if (response.statusCode == 200) {
        holder_1.remove(value);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/addproductfeatures');
        validation('Success:', "Colors has been updated.", context);
        setState(() {
          visible = false;
        });
      }
    }
  }
}
