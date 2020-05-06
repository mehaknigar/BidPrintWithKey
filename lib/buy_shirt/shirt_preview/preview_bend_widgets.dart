import 'package:bidprint/buy_shirt/shirt_preview/preview.dart';
import 'package:bidprint/buy_shirt/shirt_preview/preview_dialog_widget.dart';
import 'package:bidprint/buy_shirt/shirt_preview/preview_font_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';


double _backgroundSize = 150;
double _space = 10;
double _startAngle = 0;
double _strokeWidth = 0.0;
bool _showStroke = false;
bool _showBackground = true;
StartAngleAlignment _startAngleAlignment = StartAngleAlignment.start;
CircularTextPosition _position = CircularTextPosition.inside;
CircularTextDirection _direction = CircularTextDirection.clockwise;
double space;
void myBottomSheet(context, setstates) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 550,
          child: StatefulBuilder(builder: (BuildContext context,
              StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildCircularTextWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Background Size",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Center(
                          child: Slider(
                            value: _backgroundSize,
                            min: 50,
                            max: 250,
                            onChanged: (value) {
                              setState(() => _backgroundSize = value);
                              print(_backgroundSize);
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("SPACE",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Center(
                          child: Slider(
                            value: _space,
                            min: 0,
                            max: 50,
                            onChanged: (value) {
                              setState(() => _space = value);
                              print(_space);
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("START ANGLE",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          value: _startAngle,
                          min: 0,
                          max: 360,
                          divisions: 4,
                          label: "${_startAngle.toInt()}",
                          onChanged: (value) {
                            setState(() => _startAngle = value);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("STROKE WIDTH",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          value: _strokeWidth,
                          min: 0,
                          max: 100,
                          onChanged: _showStroke
                              ? (value) {
                                  setState(() => _strokeWidth = value);
                                }
                              : null,
                        ),
                        Checkbox(
                          value: _showStroke,
                          onChanged: (value) {
                            setState(() => _showStroke = value);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("SHOW BACKGROUND",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: _showBackground,
                          onChanged: (value) {
                            setState(() => _showBackground = value);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("POSITION",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<CircularTextPosition>(
                          value: _position,
                          items: [
                            DropdownMenuItem(
                              child: Text("INSIDE"),
                              value: CircularTextPosition.inside,
                            ),
                            DropdownMenuItem(
                              child: Text("OUTSIDE"),
                              value: CircularTextPosition.outside,
                            )
                          ],
                          onChanged: (value) {
                            setState(() => _position = value);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("DIRECTION",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<CircularTextDirection>(
                          value: _direction,
                          items: [
                            DropdownMenuItem(
                              child: Text("CLOCKWISE"),
                              value: CircularTextDirection.clockwise,
                            ),
                            DropdownMenuItem(
                              child: Text("ANTI CLOCKWISE"),
                              value: CircularTextDirection.anticlockwise,
                            )
                          ],
                          onChanged: (value) {
                            setState(() => _direction = value);
                          },
                        )
                      ],
                    ),
                    MaterialButton(
                        minWidth: double.infinity,
                        color: Colors.purple,
                        onPressed: () {
                          setstates(() {
                            bend = true;
                          });
                          print(bend);
                          // space = _space;
                          Navigator.pop(context);
                        },
                        child: Text("Done")),
                  ],
                ),
              ),
            );
          }),
        );
      });
}

Widget buildCircularTextWidget() {
  final backgroundPaint = Paint();
  if (_showBackground) {
    backgroundPaint..color = Colors.grey.shade200;
    if (_showStroke) {
      backgroundPaint
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth;
    }
  } else {
    backgroundPaint.color = Colors.transparent;
  }

  return Container(
    height: _backgroundSize,
    child: CircularText(
      children: [
        TextItem(
          text: Text(
            name,
            style: TextStyle(
              fontSize: textSize.toDouble(),
              color: color,
              fontWeight: styleB,
              fontStyle: styleI,
              decoration: styleU,
              fontFamily: font,
            ),
          ),
          space: _space,
          startAngle: _startAngle,
          startAngleAlignment: _startAngleAlignment,
          direction: _direction,
        ),
      ],
      radius: 125,
      position: _position,
      backgroundPaint: backgroundPaint,
    ),
  );
}