import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/seller/variables/custom_image.dart';
import 'package:bidprint/seller/variables/print_type.dart';
import 'package:bidprint/seller/variables/shirt_size.dart';
import 'package:bidprint/seller/variables/shirt_weight.dart';
import 'package:bidprint/seller/variables/text.dart';
import 'package:bidprint/seller/variables/text_color.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/seller/variables/shirt_color.dart';
import 'package:bidprint/seller/view_product.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductFeatures extends StatefulWidget {
  @override
  _AddProductFeaturesState createState() => _AddProductFeaturesState();
}

class _AddProductFeaturesState extends State<AddProductFeatures> {
  var holder_1 = [];
  var holder_2 = [];
  int size, size2, size3;
  var userID;
  _fetchGetColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("userID");
    setState(() {
      userID = userID;
    });
    var response = await http.post(getColorurl, body: {
      "id": userID,
      "type": "shirt",
    });
    if (response.statusCode == 200) {
      final sm = json.decode(response.body);
      if (sm.length > 0) {
        setState(() {
          holder_1 = sm;
        });
      } else {
        return null;
      }
      print(holder_1);
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<List<PrintTypeModel>> _fetchShirtSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response =
        await http.post(viewPrintTypeurl, body: {"id": userID, "type": "size"});
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<PrintTypeModel> listOfUsers = items.map<PrintTypeModel>((json) {
        return PrintTypeModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  String imgValue, imgPrice, textPrice, textValue, weight, type1,type2;
  int load;
  _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(viewProducturl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      load = items.length;
      setState(() {
        imgValue = items[0]["imageValue"].toString();
        imgPrice = items[0]["imagePrice"].toString();
        textPrice = items[0]["customTextPrice"].toString();
        textValue = items[0]["customText"].toString();
        weight = items[0]["weight"].toString();
        type1 = items[0]["type"].toString();
        type2 = items[0]["typ"].toString();
      });
    } else {
      throw Exception('Failed to load internet');
    }
  }

  _fetchGetTextColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString("userID");
    var response = await http.post(getColorurl, body: {
      "id": userID,
      "type": "text",
    });
    if (response.statusCode == 200) {
      final sm2 = json.decode(response.body);
      if (sm2.length > 0) {
        setState(() {
          holder_2 = sm2;
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
    _fetchGetColor();
    _fetchShirtSize();
    _fetchGetTextColor();
    _fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: SingleChildScrollView(
        child: load == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Shirt Colors:", style: heading2),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyColors(holder_1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (holder_1.length > 0) {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "color"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myShirtColorDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Shirt Size:", style: heading2),
                        FutureBuilder<List<PrintTypeModel>>(
                            future: _fetchShirtSize(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                    child: CircularProgressIndicator());
                              if (size == 0) {
                                return Center(child: Text("--No Size Found--"));
                              }
                              return Container(
                                child: size > 0
                                    ? Container(
                                        height: 120,
                                        padding: const EdgeInsets.all(8),
                                        child: StaggeredGridView.count(
                                          crossAxisCount: 4,
                                          children: snapshot.data
                                              .map(
                                                (type) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        height: 5.0,
                                                        width: 5.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(type.shirtSize,
                                                              style: TextStyle(
                                                                  color:
                                                                      themebutton,
                                                                  fontSize:
                                                                      16)),
                                                          SizedBox(width: 5),
                                                          Text(
                                                              "  (\$" +
                                                                  type
                                                                      .shirtPrice +
                                                                  ")",
                                                              style: TextStyle(
                                                                  color:
                                                                      themebutton)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          staggeredTiles: snapshot.data
                                              .map<StaggeredTile>(
                                                  (_) => StaggeredTile.fit(2))
                                              .toList(),
                                          mainAxisSpacing: 3.0,
                                          crossAxisSpacing: 0.0,
                                        ),
                                      )
                                    : null,
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (size > 0) {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "size"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myShirtSizeDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Shirt Weight:", style: heading2),
                        Container(
                            padding: EdgeInsets.all(15),
                            child: weight == 'null'
                                ? Center(child: Text("--No Weight Set--"))
                                : Text(weight + " lb")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (weight != 'null') {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "weight"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myWeightDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Print Type:", style: heading2),
                        Container(
                            padding: EdgeInsets.all(15),
                            child: type1 == '' && type2 == ''
                                ? Center(child: Text("--No Print Type Set--"))
                                : Text(type1 +'\n'+type2)),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (weight != 'null') {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "printType"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                printTypeDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Custom Image:", style: heading2),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: imgValue == "Yes"
                              ? Text("Yes at the rate of \$" + imgPrice)
                              : Center(
                                  child: Text("--No Value Set--"),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (imgValue == "Yes") {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "image"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myCustomImageDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Custom Text:", style: heading2),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: textValue == "Yes"
                              ? Text("Yes at the rate of \$" + textPrice)
                              : Center(
                                  child: Text("--No Value Set--"),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (textPrice != "null") {
                                  await http.post(deleteProdFeaturesurl,
                                      body: {"id": userID, "table": "text"});
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myCustomTextDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: lightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Text Color:", style: heading2),
                        MyTextColors(holder_2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              highlightColor: Colors.red.shade100,
                              borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                if (holder_2.length > 0) {
                                  await http.post(deleteProdFeaturesurl, body: {
                                    "id": userID,
                                    "table": "textColor"
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/addproductfeatures');
                                } else {
                                  return myToast("No Data to delete");
                                }
                              },
                              child: Text(
                                "DELETE",
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ),
                            OutlineButton(
                              highlightColor: Colors.blue.shade100,
                              borderSide: BorderSide(color: Colors.blue[700]),
                              onPressed: () {
                                myTextColorDialog(context);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

void myShirtColorDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Shirt Color!"),
          content: ShirtColor(),
        );
      });
}

void myTextColorDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Text Color!"),
          content: TextColor(),
        );
      });
}

void myShirtSizeDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Shirt Size!"),
          content: ShirtSize(),
        );
      });
}

void myCustomTextDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Custom Text!"),
          content: CustomText(),
        );
      });
}

void myCustomImageDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Custom Image!"),
          content: CustomImage(),
        );
      });
}

void myWeightDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Shirt Weight"),
          content: ShirtWeight(),
        );
      });
}
void printTypeDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGrey,
          title: Text("Shirt Weight"),
          content: PrintType(),
        );
      });
}