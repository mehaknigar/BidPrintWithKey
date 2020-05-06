import 'package:bidprint/account/reset_password.dart';
import 'package:bidprint/account/utils/code.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhoneAuthVerify extends StatefulWidget {
  final String email, user;
  PhoneAuthVerify(this.email,this.user);
  Color cardBackgroundColor = themebottom;

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState(email, user);
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  final String email, user;
  _PhoneAuthVerifyState(this.email,this.user);
  double _height, _width;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  @override
  void initState() {
    FirebasePhoneAuth.phoneAuthState.stream
        .listen((PhoneAuthState state) => print(state));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar:
          TopBar().getAppBar(Icon(Icons.lock, color: transparent), "", null),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Card(
        color: widget.cardBackgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          height: _height * 8 / 10,
          width: _width * 8 / 10,
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Image.asset("images/logowhite.png"),
          ),

          //  Info text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Please enter the ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: 'One Time Password',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                          text: ' sent to your mobile',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),

          SizedBox(height: 32.0),

          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'VERIFY',
                style: TextStyle(
                    color: widget.cardBackgroundColor, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          )
        ],
      );

  signIn() {
    if (code.length != 6) {
      validation(
          "Error",
          "Something went wrong, please try again or contact our Customer Support.",
          context);
    }else{
    bool verified = FirebasePhoneAuth.signInWithPhoneNumber(smsCode: code);
    print(verified);
    if (verified) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(email,user),
        ),
      );
    } else {
 validation(
          "Error",
          "Something went wrong, please try again or contact our Customer Support.",
          context);
      print( "somehting wnet wrong!");
    }}
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: key.contains("1") ? true : false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
          //  decoration: InputDecoration(
          //      contentPadding: const EdgeInsets.only(
          //          bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
          //      focusedBorder: OutlineInputBorder(
          //          borderRadius: BorderRadius.circular(5.0),
          //          borderSide:
          //              BorderSide(color: Colors.blueAccent, width: 2.25)),
          //      border: OutlineInputBorder(
          //          borderRadius: BorderRadius.circular(5.0),
          //          borderSide: BorderSide(color: Colors.white))),
        ),
      );
}
