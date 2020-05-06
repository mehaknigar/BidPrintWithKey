import 'package:flutter/material.dart';


///// TEXT DESIGNING /////  FONT FAMILY, FONT Size, Font Style, Font Color

String r = "Roboto";
String a = "Arial";
String c = "Cursive";
String t = "Times New Roman";
String s = "Calibri";
String font;
void showFont(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[200],
          height: 320,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Roboto (Default)",
                      style: TextStyle(fontFamily: r, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        font = r;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Calibri ",
                      style: TextStyle(fontFamily: s, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        font = s;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Arial ",
                      style: TextStyle(fontFamily: a, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        font = a;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Cursive ",
                      style: TextStyle(fontFamily: c, fontSize: 24),
                    ),
                    onTap: () {
                      setstates(() {
                        font = c;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Times New Roman ",
                      style: TextStyle(fontFamily: t, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        font = t;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ]),
          ),
        );
      });
}

int textSize = 30;
int _textSize = 30;
void showSize(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            color: Colors.grey[200],
            height: 250,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        height: 80,
                        child: Text(
                          "Aa",
                          style: TextStyle(fontSize: _textSize.toDouble()),
                        )),
                    Row(
                      children: <Widget>[
                        Text(
                          "Set Size",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 30),
                        QuantityButton("-", () {
                          setState(() {
                            if (_textSize != 1) {
                              _textSize--;
                            }
                          });
                        }),
                        RawMaterialButton(
                          onPressed: null,
                          constraints:
                              BoxConstraints.tightFor(width: 60, height: 40),
                          fillColor: Colors.grey[300],
                          child: Text(
                            _textSize.toString(),
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[600]),
                          ),
                        ),
                        QuantityButton("+", () {
                          setState(() {
                            if (_textSize != 80) {
                              _textSize++;
                            }
                          });
                        }),
                      ],
                    ),
                    MaterialButton(
                        minWidth: double.infinity,
                        color: Colors.purple,
                        onPressed: () {
                          setstates(() {
                            textSize = _textSize;
                          });
                          print(textSize);
                          Navigator.pop(context);
                        },
                        child: Text("Done")),
                  ],
                ),
              );
            }));
      });
}

class QuantityButton extends StatelessWidget {
  final String child;
  final Function onPress;
  QuantityButton(this.child, this.onPress);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(width: 26, height: 34),
      fillColor: Colors.grey[300],
      child: Text(
        child,
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}

FontStyle _styleI = FontStyle.italic;
FontStyle styleI;
FontWeight _styleB = FontWeight.bold;
FontWeight styleB;
TextDecoration _styleU = TextDecoration.underline;
TextDecoration styleU;
FontStyle _styleNI = FontStyle.normal;
FontWeight _styleNB = FontWeight.normal;
TextDecoration _styleNU = TextDecoration.none;
void showStyle(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[200],
          height: 280,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Normal Text",
                      style: TextStyle(
                          fontStyle: _styleNI,
                          fontSize: 20,
                          fontWeight: _styleNB,
                          decoration: _styleNU),
                    ),
                    onTap: () {
                      setstates(() {
                        styleI = _styleNI;
                        styleB = _styleNB;
                        styleU = _styleNU;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Italic Text",
                      style: TextStyle(fontStyle: _styleI, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        styleI = _styleI;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Bold Text",
                      style: TextStyle(fontWeight: _styleB, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        styleB = _styleB;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Underline Text",
                      style: TextStyle(decoration: _styleU, fontSize: 20),
                    ),
                    onTap: () {
                      setstates(() {
                        styleU = _styleU;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ]),
          ),
        );
      });
}

Color color = Colors.black;
String colorString;
void showbt(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[200],
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Text("Select Text Color"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.grey;
                          colorString = "Grey";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.black;
                          colorString = "Black";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.white;
                          colorString = "White";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.lightBlue;
                          colorString = "Light Blue";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.lightBlue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.blue[900];
                          colorString = "Blue";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.blue[900]),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.purple;
                          colorString = "Purple";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.orange;
                          colorString = "Orange";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.orange),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.red;
                          colorString = "Red";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.red),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.pink[300];
                          colorString = "Pink";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.pink[300]),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.yellow;
                          colorString = "Yellow";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.yellow),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.green;
                          colorString = "Light Green";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.green),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          color = Colors.green[900];
                          colorString = "Green";
                        });
                        print('color : $color');
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.brightness_1,
                            size: 60, color: Colors.green[900]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
