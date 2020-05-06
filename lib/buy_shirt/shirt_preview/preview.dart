import 'dart:convert';
import 'dart:typed_data';
import 'package:bidprint/buy_shirt/shirt_preview/preview_bend_widgets.dart';
import 'package:bidprint/buy_shirt/shirt_preview/preview_dialog_widget.dart';
import 'package:bidprint/buy_shirt/shirt_preview/preview_font_widgets.dart';
import 'package:bidprint/buy_shirt/shirt_preview/previewscreenshot.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:ui' as ui;

class ShirtPreview extends StatefulWidget {
  final String dropdownShirtColor,
      design,
      dropdownShirtSize,
      dopdownShirtStyle,
      printtype;
  final int quantity;
  ShirtPreview(this.dropdownShirtColor, this.design, this.dropdownShirtSize,
      this.dopdownShirtStyle, this.printtype, this.quantity);
  @override
  _ShirtPreviewState createState() => _ShirtPreviewState(dropdownShirtColor,
      design, dropdownShirtSize, dopdownShirtStyle, printtype, quantity);
}

class Position {
  Position(this._x, this._y);

  setPosition(double x, double y) {
    this._x = x;
    this._y = y;
  }

  double get x {
    return this._x;
  }

  double get y {
    return this._y;
  }

  double _x;
  double _y;
}

Future<File> file;
String base64Image;
File tmpFile;
bool bend = false;
bool touch = false;
bool touchImg = false;
bool touchShape = false;

class _ShirtPreviewState extends State<ShirtPreview> {
  static GlobalKey screen = new GlobalKey();
  var png;
  final String dropdownShirtColor,
      design,
      dropdownShirtSize,
      dopdownShirtStyle,
      printtype;
  final int quantity;
  _ShirtPreviewState(
      this.dropdownShirtColor,
      this.design,
      this.dropdownShirtSize,
      this.dopdownShirtStyle,
      this.printtype,
      this.quantity);
  List<Position> pos = List<Position>();
  @override
  void initState() {
    name = '';
    bend = false;
    touch = false;
    touchImg = false;
    touchShape = false;
    color = Colors.black;
    colorString = "Black";
    textSize = 30;
    file = null;
    _imgSize = 100;
    _shapeSize = 100;
    font = "Roboto";
    textSize = 30;
    styleI = FontStyle.normal;
    styleB = FontWeight.normal;
    styleU = TextDecoration.none;
    png = null;
    shape = '';
    super.initState();
  }

  Decoration _decoraation = BoxDecoration(
    border: Border.all(color: Colors.blue, width: 2),
    color: Color.fromRGBO(255, 255, 255, 0.2),
    borderRadius: BorderRadius.circular(5),
  );

  String imageFile;
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    pos.add(Position(width / 3, height / 3));
    pos.add(Position(width * 0.2, height * 0.2));
    pos.add(Position(25, 100));

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: themebtn,
        progressIndicator: CircularProgressIndicator(),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setstates) {
          return GestureDetector(
            onTap: () {
              setState(() {
                touch = false;
                touchImg = false;
                touchShape = false;
              });
              print(touch);
            },
            child: Stack(
              // fit: StackFit.expand,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: FlatButton(
                          onPressed: null,
                          child: Text(""),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: RaisedButton(
                          color: themeColor,
                          onPressed: () async {
                            if (file != null) {
                              String fileName = tmpFile.path.split('/').last;
                              setState(() {
                                imageFile = fileName;
                              });
                            }
                            print(
                                "$dropdownShirtColor , $dropdownShirtSize, $bend , $printtype , $design");
                            print(
                                "$dopdownShirtStyle , $name, $colorString , $font , $imageFile");
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) => ShippingAddress(
                            //             printtype,
                            //             dopdownShirtStyle,
                            //             bend,
                            //             dropdownShirtColor,
                            //             design,
                            //             quantity,
                            //             dropdownShirtSize,
                            //             name,
                            //             colorString,
                            //             font,
                            //             base64Image,
                            //             imageFile,shape))));

                            RenderRepaintBoundary boundary =
                                screen.currentContext.findRenderObject();
                            ui.Image image = await boundary.toImage();
                            ByteData byteData = await image.toByteData(
                                format: ui.ImageByteFormat.png);
                            png = byteData.buffer.asUint8List();

                            String baseimag64 = base64Encode(png);
                            print("ss " + baseimag64);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewScreenshot(
                                      baseimag64,
                                      printtype,
                                      dopdownShirtStyle,
                                      bend,
                                      dropdownShirtColor,
                                      design,
                                      quantity,
                                      dropdownShirtSize,
                                      name,
                                      colorString,
                                      font,
                                      base64Image,
                                      imageFile,
                                      shape),
                                ));
                            print(file);
                          },
                          child: Text(
                            "Done",
                            style: buttonText,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                RepaintBoundary(
                  key: screen,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 500,
                          child: Image.asset(
                            "images/shirts/$dropdownShirtColor.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: CustomMultiChildLayout(
                          delegate: DragArea(pos),
                          children: <Widget>[
                            LayoutId(
                              id: 't0',
                              child: Container(
                                child: name == ''
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            touch = true;
                                            touchShape = false;
                                            touchImg = false;
                                          });
                                          print(touch);
                                        },
                                        child: Container(
                                          child: bend == true
                                              ? Draggable(
                                                  feedback: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: touch
                                                          ? _decoraation
                                                          : BoxDecoration(),
                                                      child: Material(
                                                          type: MaterialType
                                                              .transparency,
                                                          child:
                                                              buildCircularTextWidget())),
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: touch
                                                          ? _decoraation
                                                          : BoxDecoration(),
                                                      child:
                                                          buildCircularTextWidget()),
                                                  childWhenDragging:
                                                      Container(),
                                                  onDragEnd:
                                                      (DraggableDetails d) {
                                                    setState(() {
                                                      pos[0].setPosition(
                                                          d.offset.dx,
                                                          d.offset.dy);
                                                    });
                                                  },
                                                )
                                              : Draggable(
                                                  feedback: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                      decoration: touch
                                                          ? _decoraation
                                                          : BoxDecoration(),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          name,
                                                          style: TextStyle(
                                                            fontSize: textSize
                                                                .toDouble(),
                                                            color: color,
                                                            fontWeight: styleB,
                                                            fontStyle: styleI,
                                                            decoration: styleU,
                                                            fontFamily: font,
                                                          ),
                                                        ),
                                                      )),
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                      decoration: touch
                                                          ? _decoraation
                                                          : BoxDecoration(),
                                                      child: Text(
                                                        name,
                                                        style: TextStyle(
                                                          fontSize: textSize
                                                              .toDouble(),
                                                          color: color,
                                                          fontWeight: styleB,
                                                          fontStyle: styleI,
                                                          decoration: styleU,
                                                          fontFamily: font,
                                                        ),
                                                      )),
                                                  childWhenDragging:
                                                      Container(),
                                                  onDragEnd:
                                                      (DraggableDetails d) {
                                                    setState(() {
                                                      pos[0].setPosition(
                                                          d.offset.dx,
                                                          d.offset.dy);
                                                    });
                                                  },
                                                ),
                                        ),
                                      ),
                              ),
                            ),
                            LayoutId(
                              id: 't1',
                              child: Container(
                                child: file == null
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            touchImg = true;
                                            touchShape = false;
                                            touch = false;
                                          });
                                          print(touchImg);
                                        },
                                        child: Draggable(
                                          feedback: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: touchImg
                                                ? _decoraation
                                                : BoxDecoration(),
                                            child: Material(
                                                type: MaterialType.transparency,
                                                child: showImage(setstates)),
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.all(15),
                                              decoration: touchImg
                                                  ? _decoraation
                                                  : BoxDecoration(),
                                              child: showImage(setstates)),
                                          childWhenDragging: Container(),
                                          onDragEnd: (DraggableDetails d) {
                                            setState(() {
                                              pos[1].setPosition(
                                                  d.offset.dx, d.offset.dy);
                                            });
                                          },
                                        ),
                                      ),
                              ),
                            ),
                            LayoutId(
                              id: 't2',
                              child: Container(
                                child: shape == ''
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            touchShape = true;
                                            touch = false;
                                            touchImg = false;
                                          });
                                          print(touchShape);
                                        },
                                        child: Draggable(
                                          feedback: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: touchShape
                                                ? _decoraation
                                                : BoxDecoration(),
                                            child: Material(
                                                type: MaterialType.transparency,
                                                child: Image.asset(
                                                  "images/shapes/$shape",
                                                  width: _shapeSize,
                                                )),
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.all(15),
                                              decoration: touchShape
                                                  ? _decoraation
                                                  : BoxDecoration(),
                                              child: Image.asset(
                                                "images/shapes/$shape",
                                                width: _shapeSize,
                                              )),
                                          childWhenDragging: Container(),
                                          onDragEnd: (DraggableDetails d) {
                                            setState(() {
                                              pos[2].setPosition(
                                                  d.offset.dx, d.offset.dy);
                                            });
                                          },
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: touchShape
                          ? BottomNavigationBar(
                              onTap: (index) {
                                print("Selected Index: $index");
                                if (index == 0) {
                                  myShapesDialog(context, setstates);
                                }
                                if (index == 1) {
                                  myShapeSizeSheet(context, setstates);
                                }
                                if (index == 2) {
                                  setState(() {
                                    shape = '';
                                    touchShape = false;
                                  });
                                }
                              },
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.edit),
                                  title: Text('Change'),
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.photo_size_select_large),
                                  title: Text('Size'),
                                ),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.delete),
                                    title: Text('Delete')),
                              ],
                              type: BottomNavigationBarType.fixed,
                              fixedColor: white,
                              backgroundColor: themebutton,
                              unselectedItemColor: white,
                            )
                          : null,
                    ),
                    Container(
                      child: touchImg
                          ? BottomNavigationBar(
                              onTap: (index) {
                                print("Selected Index: $index");
                                if (index == 0) {
                                  setState(() {
                                    file = ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                  });
                                }
                                if (index == 1) {
                                  myImageSizeSheet(context, setstates);
                                }
                                if (index == 2) {
                                  setState(() {
                                    file = null;
                                    imageFile = null;
                                    base64Image = null;
                                    touchImg = false;
                                  });
                                }
                              },
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.edit),
                                  title: Text('Change'),
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.photo_size_select_large),
                                  title: Text('Size'),
                                ),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.delete),
                                    title: Text('Delete')),
                              ],
                              type: BottomNavigationBarType.fixed,
                              fixedColor: white,
                              backgroundColor: themebutton,
                              unselectedItemColor: white,
                            )
                          : null,
                    ),
                    Container(
                      child: touch
                          ? Column(
                              children: <Widget>[
                                BottomNavigationBar(
                                  onTap: (index) {
                                    print("Selected Index: $index");
                                    if (index == 0) {
                                      showFont(context, setstates);
                                    }
                                    if (index == 1) {
                                      showSize(context, setstates);
                                    }
                                    if (index == 2) {
                                      showStyle(context, setstates);
                                    }
                                    if (index == 3) {
                                      setState(() {
                                        bend = false;
                                      });
                                    }
                                    if (index == 4) {
                                      myBottomSheet(context, setstates);
                                    }
                                  },
                                  items: [
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.font_download),
                                      title: Text('Font'),
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.format_size),
                                      title: Text('Size'),
                                    ),
                                    BottomNavigationBarItem(
                                        icon: Icon(Icons.format_italic),
                                        title: Text('Style')),
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.straighten),
                                      title: Text('Straight'),
                                    ),
                                    BottomNavigationBarItem(
                                        icon: Icon(Icons.low_priority),
                                        title: Text('Bend')),
                                  ],
                                  type: BottomNavigationBarType.fixed,
                                  fixedColor: white,
                                  backgroundColor: themebottom,
                                  unselectedItemColor: white,
                                ),
                                BottomNavigationBar(
                                  onTap: (index) {
                                    print("Selected Index: $index");
                                    if (index == 0) {
                                      myDialog(context, setstates);
                                    }
                                    if (index == 1) {
                                      showbt(context, setstates);
                                    }
                                    if (index == 2) {
                                      setState(() {
                                        name = '';
                                        touch = false;
                                      });
                                    }
                                  },
                                  items: [
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.format_color_fill),
                                      title: Text('Color'),
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ),
                                  ],
                                  type: BottomNavigationBarType.fixed,
                                  fixedColor: white,
                                  backgroundColor: themebutton,
                                  unselectedItemColor: white,
                                ),
                              ],
                            )
                          : Container(
                              child: touchImg == true || touchShape == true
                                  ? null
                                  : BottomNavigationBar(
                                      onTap: (index) {
                                        print("Selected Index: $index");
                                        if (index == 0) {
                                          myDialog(context, setstates);
                                        }
                                        if (index == 1) {
                                          setState(() {
                                            file = ImagePicker.pickImage(
                                                source: ImageSource.gallery);
                                          });
                                        }
                                        if (index == 2) {
                                          myShapesDialog(context, setstates);
                                        }
                                        if (index == 3) {
                                          myHintDialog(context);
                                        }
                                      },
                                      items: [
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.font_download),
                                          title: Text('Text'),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.photo_library),
                                          title: Text('Photo'),
                                        ),
                                        BottomNavigationBarItem(
                                            icon: Icon(Icons.art_track),
                                            title: Text('Shapes')),
                                        BottomNavigationBarItem(
                                            icon: Icon(Icons.info),
                                            title: Text('Hint')),
                                      ],
                                      type: BottomNavigationBarType.fixed,
                                      fixedColor: white,
                                      backgroundColor: themebutton,
                                      unselectedItemColor: white,
                                    ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class DragArea extends MultiChildLayoutDelegate {
  List<Position> _p = List<Position>();

  DragArea(this._p);

  @override
  void performLayout(Size size) {
    for (int i = 0; i < 3; i++) {
      layoutChild('t' + i.toString(), BoxConstraints.loose(size));
      positionChild('t' + i.toString(), Offset(_p[i].x, _p[i].y));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

String shape = '';
void myShapesDialog(context, setstates) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "bear.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/bear.png",
                        width: 70,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "catdog.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/catdog.png",
                        width: 70,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "smoothy.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/smoothy.png",
                        width: 60,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "movie.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/movie.png",
                        width: 60,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "dish.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/dish.png",
                        width: 60,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "table.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/table.png",
                        width: 60,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "tikka.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/tikka.png",
                        width: 60,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "milk.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/milk.png",
                        width: 60,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "ice.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/ice.png",
                        width: 60,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "icecream.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/icecream.png",
                        width: 60,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "heart.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/heart.png",
                        width: 80,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setstates(() {
                          shape = "butter.png";
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "images/shapes/butter.png",
                        width: 80,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
          ],
        );
      });
}

double _shapeSize = 100.0;
void myShapeSizeSheet(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 450,
          padding: EdgeInsets.all(10),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/shapes/$shape", width: _shapeSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("SPACE",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Center(
                      child: Slider(
                        value: _shapeSize,
                        min: 20,
                        max: 300,
                        onChanged: (value) {
                          setState(() => _shapeSize = value);
                          print(_shapeSize);
                        },
                      ),
                    )
                  ],
                ),
                MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.purple,
                    onPressed: () {
                      setstates(() {
                        _shapeSize = _shapeSize;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Done")),
              ],
            );
          }),
        );
      });
}

Widget showImage(setstates) {
  print(file);
  return FutureBuilder<File>(
    future: file,
    builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          null != snapshot.data) {
        File data = snapshot.data;
        tmpFile = data;
        print(tmpFile);
        base64Image = base64Encode(snapshot.data.readAsBytesSync());
        return Container(
          height: _imgSize,
          child: Image.file(
            tmpFile,
            // fit: BoxFit.fill,
          ),
        );
      } else if (null != snapshot.error) {
        return const Text(
          'Error Picking Image',
          textAlign: TextAlign.center,
        );
      } else {
        return const Text(
          '',
          textAlign: TextAlign.center,
        );
      }
    },
  );
}

double _imgSize = 100.0;
void myImageSizeSheet(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 450,
          padding: EdgeInsets.all(10),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                showImage(setstates),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("SPACE",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Center(
                      child: Slider(
                        value: _imgSize,
                        min: 20,
                        max: 300,
                        onChanged: (value) {
                          setState(() => _imgSize = value);
                          print(_imgSize);
                        },
                      ),
                    )
                  ],
                ),
                MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.purple,
                    onPressed: () {
                      setstates(() {
                        _imgSize = _imgSize;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Done")),
              ],
            );
          }),
        );
      });
}
