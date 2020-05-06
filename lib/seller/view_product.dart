import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:flutter/material.dart';

class MyColors extends StatelessWidget {
  final List holder;
  MyColors(this.holder);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: holder.length > 0
          ? Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('White')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/White.png",
                                    width: 40,
                                  ),
                                  Text("White", style: small)
                                ],
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('Light-Blue')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/Light-Blue.png",
                                    width: 40,
                                  ),
                                  Text("Light Blue", style: small)
                                ],
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('Light-Green')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/Light-Green.png",
                                    width: 40,
                                  ),
                                  Text("Light Green", style: small)
                                ],
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('Red')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/Red.png",
                                    width: 40,
                                  ),
                                  Text("Red", style: small)
                                ],
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('Blue')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/Blue.png",
                                    width: 40,
                                  ),
                                  Text("Blue", style: small)
                                ],
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: holder.contains('Orange')
                            ? Column(
                                children: <Widget>[
                                  Image.asset(
                                    "images/shirts/Orange.png",
                                    width: 40,
                                  ),
                                  Text("Orange", style: small)
                                ],
                              )
                            : null,
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Green')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Green.png",
                                  width: 40,
                                ),
                                Text("Green", style: small)
                              ],
                            )
                          : null,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Yellow')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Yellow.png",
                                  width: 40,
                                ),
                                Text("Yellow", style: small)
                              ],
                            )
                          : null,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Pink')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Pink.png",
                                  width: 40,
                                ),
                                Text("Pink", style: small)
                              ],
                            )
                          : null,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Black')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Black.png",
                                  width: 40,
                                ),
                                Text("Black", style: small)
                              ],
                            )
                          : null,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Grey')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Grey.png",
                                  width: 40,
                                ),
                                Text("Grey", style: small)
                              ],
                            )
                          : null,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: holder.contains('Purple')
                          ? Column(
                              children: <Widget>[
                                Image.asset(
                                  "images/shirts/Purple.png",
                                  width: 40,
                                ),
                                Text("Purple", style: small)
                              ],
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            )
          : Center(child: Text("--No Color Found--")),
    );
  }
}

class MyTextColors extends StatelessWidget {
  final List holder;
  MyTextColors(this.holder);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: holder.length > 0
          ? Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('White')
                      ? Container(
                          color: Colors.white,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Light-Blue')
                      ? Container(
                          color: Colors.lightBlue,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Light-Green')
                      ? Container(
                          color: Colors.green,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Red')
                      ? Container(
                          color: Colors.red,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Blue')
                      ? Container(
                          color: Colors.blue[900],
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Orange')
                      ? Container(
                          color: Colors.orange,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Green')
                      ? Container(
                          color: Colors.green[900],
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Yellow')
                      ? Container(
                          color: Colors.yellow,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Pink')
                      ? Container(
                          color: Colors.pink[300],
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Black')
                      ? Container(
                          color: Colors.black,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Grey')
                      ? Container(
                          color: Colors.grey,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: holder.contains('Purple')
                      ? Container(
                          color: Colors.purple,
                          width: 25,
                          height: 25,
                        )
                      : null,
                ),
              ],
            )
          : Center(child: Text("--No Color Found--")),
    );
  }
}

class MyShirtType extends StatelessWidget {
  final Future fetchData;
  final int size;
  final double height;
  final Axis scroll;
  MyShirtType(this.fetchData, this.size, this.height, this.scroll);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<PrintTypeModel>>(
          future: fetchData,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (size == 0) {
              return Center(child: Text("--No Data Found--"));
            }
            return Container(
              child: size > 0
                  ? Container(
                      height: height,
                      child: ListView(
                        scrollDirection: scroll,
                        children: snapshot.data
                            .map((type) => Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 5.0,
                                        width: 5.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(type.shirtSize, style: title22),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ))
                  : null,
            );
          }),
    );
  }
}
