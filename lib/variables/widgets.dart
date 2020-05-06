import 'package:bidprint/variables/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

//====================FORM FIELD ===============================//
class MyFormField extends StatelessWidget {
  final double size;
  final Widget formfield;
  MyFormField(this.size, this.formfield);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: size,
        child: formfield,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

signForm(String name, Icon icon) {
  return InputDecoration(
    //  isDense: true,
    hintText: name,
    prefixIcon: icon,
    contentPadding: EdgeInsets.all(15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: themebutton),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}



//////////////////////// BUTTON ///////////////////////////////

class AccountButton extends StatelessWidget {
  final Function onPress;
  final String name;
  final Color clr;
  AccountButton(this.onPress, this.name, this.clr);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: clr,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
        child: Text(
          name,
          style: TextStyle(fontSize: 16, color: white),
        ),
      ),
    );
  }
}
//=========================CACHE IMAGE ===================//

class CacheImage extends StatelessWidget {
  final String image;
  final double size;
  CacheImage(this.image, this.size);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: size,
      height: size,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

///////////////// PAGE TRANSITION ///////////////////
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
//======================== QUANTITY BUTTON =================//

class QuantityButton extends StatelessWidget {
  final String child;
  final Function onPress;
  QuantityButton(this.child, this.onPress);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(width: 22, height: 26),
      fillColor: Colors.grey[300],
      child: Text(
        child,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

/////////////////////////PLAY STORE////////////////

void klaunchURL() async {
  const url =
      'https://play.google.com/store/apps/details?id=com.skylite.BidPrint';
  if (await canLaunch(url)) {
    await launch(url); //forceWebView: true
  } else {
    throw 'Could not launch $url';
  }
}

//////////////////////////////////////////////
myToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
