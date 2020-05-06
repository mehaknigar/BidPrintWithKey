import 'package:flutter/material.dart';



void myHintDialog(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 280,
            child: Column(
              children: <Widget>[
                Text("Touch on the item (this may be text, image or shape) for options to edit the item"),
                Text("\nTouch the item to DRAG AND DROP on the screen"),
                Text("\nTouch anywhere on the screen to dismiss editing portion"),
                Text("\nClick on Done (at the top right corner) when you have done with designing and wants to continue"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        );
      });
}


String name = '';
String nm;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
void myDialog(context, setstates) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter The Text Here!"),
          content: Form(
            autovalidate: true,
            key: _formKey,
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Text you want to print'),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                nm = value;
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  setstates(() {
                    name = nm;
                  });
                  
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        );
      });
}