import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/address/shipping_address.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:flutter/material.dart';

class PreviewScreenshot extends StatefulWidget {
  final String photo,
      printtype,
      dopdownShirtStyle,
      dropdownShirtColor,
      design,
      dropdownShirtSize,
      name,
      colorString,
      font,
      base64Image,
      imageFile,
      shape;
  final bool bend;
  final int quantity;
  PreviewScreenshot(
      this.photo,
      this.printtype,
      this.dopdownShirtStyle,
      this.bend,
      this.dropdownShirtColor,
      this.design,
      this.quantity,
      this.dropdownShirtSize,
      this.name,
      this.colorString,
      this.font,
      this.base64Image,
      this.imageFile,
      this.shape);
  @override
  _PreviewScreenshotState createState() => _PreviewScreenshotState(
      photo,
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
      shape);
}

class _PreviewScreenshotState extends State<PreviewScreenshot> {
  final String photo,
      printtype,
      dopdownShirtStyle,
      dropdownShirtColor,
      design,
      dropdownShirtSize,
      name,
      colorString,
      font,
      base64Image,
      imageFile,
      shape;
  final bool bend;
  final int quantity;
  _PreviewScreenshotState(
      this.photo,
      this.printtype,
      this.dopdownShirtStyle,
      this.bend,
      this.dropdownShirtColor,
      this.design,
      this.quantity,
      this.dropdownShirtSize,
      this.name,
      this.colorString,
      this.font,
      this.base64Image,
      this.imageFile,
      this.shape);

  var realImage;
  var screenshot;

  _printImage() {
    final _byteImage = Base64Decoder().convert(photo);
    Widget img = Image.memory(_byteImage);
    setState(() {
      screenshot = img;
    });
  }

  @override
  void initState() {
    super.initState();
    _printImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "Shirt Preview", null),
      body: Center(
        child:
            Container(height: MediaQuery.of(context).size.height, child: screenshot),
      ),
      bottomNavigationBar: Container(
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
                  print(
                      "$dropdownShirtColor , $dropdownShirtSize, $bend , $printtype , $design");
                  print(
                      "$dopdownShirtStyle , $name, $colorString , $font , $imageFile, $photo");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ShippingAddress(photo,
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
                              shape))));
                },
                child: Text(
                  "Continue",
                  style: buttonText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // _image() async {
  //   var response = await http.post(imageurl, body: {
  //     "imageName": '123414.png',
  //     "image": photo,
  //   });

  //   if (response.statusCode == 200) {
  //     print("stored successfully");
  //   }
  // }
}
