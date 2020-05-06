import 'package:flutter/material.dart';

doubleQueDialog(String title, String cntnt, String y1, Function onPress1,
    String y2, Function onPress2, context) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: Colors.white, //Color(0xff183132),
              contentPadding: EdgeInsets.fromLTRB(28.0, 5.0, 28.0, 5.0),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                title,
                style: TextStyle(color: Color(0xff183132)),
              ),
              content: Text(
                cntnt,
                style: TextStyle(color: Color(0xff183132)),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    y1,
                    style: TextStyle(color: Color(0xff183132), fontSize: 16),
                  ),
                  onPressed: onPress1,
                ),
                FlatButton(
                  child: Text(
                    y2,
                    style: TextStyle(color: Color(0xff183132), fontSize: 16),
                  ),
                  onPressed: onPress2,
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}


//////////////////  DIALOG BOX  /////////////////////////
void validation(String title, String text, context) {
  String tit = title;
  String txt = text;
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: Colors.white, //Color(0xff183132),
              contentPadding: EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                tit,
                style: TextStyle(color: Color(0xff183132)),
              ),
              content: Text(
                txt,
                style: TextStyle(color: Color(0xff183132)),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xff183132), fontSize: 16),
                    )),
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}