import 'dart:math';
import 'package:bidprint/chat/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

class OrderHistoryExtend extends StatefulWidget {
  final String orderId,
      firstname,
      lastname,
      date,
      printType,
      textType,
      shirtStyle,
      track,
      address,
      country,
      city,
      zone,
      shirtColor,
      size,
      quantity,
      text,
      textColor,
      font,
      designType,
      image,
      cost,
      totalCost,
      sub,
      shipping,
      sellerId,
      sellerf,
      sellerl,
      sellerEm,
      sellerNumb,
      shape,
      ss;
  OrderHistoryExtend(
      this.orderId,
      this.firstname,
      this.lastname,
      this.date,
      this.printType,
      this.textType,
      this.shirtStyle,
      this.track,
      this.address,
      this.country,
      this.city,
      this.zone,
      this.shirtColor,
      this.size,
      this.quantity,
      this.text,
      this.textColor,
      this.font,
      this.designType,
      this.image,
      this.cost,
      this.totalCost,
      this.sub,
      this.shipping,
      this.sellerId,
      this.sellerf,
      this.sellerl,
      this.sellerEm,
      this.sellerNumb,
      this.shape,
      this.ss);
  @override
  _OrderHistoryExtendState createState() => _OrderHistoryExtendState(
      orderId,
      firstname,
      lastname,
      date,
      printType,
      textType,
      shirtStyle,
      track,
      address,
      country,
      city,
      zone,
      shirtColor,
      size,
      quantity,
      text,
      textColor,
      font,
      designType,
      image,
      cost,
      totalCost,
      sub,
      shipping,
      sellerId,
      sellerf,
      sellerl,
      sellerEm,
      sellerNumb,
      shape,
      ss);
}

class _OrderHistoryExtendState extends State<OrderHistoryExtend> {
  final String orderId,
      firstname,
      lastname,
      date,
      printType,
      textType,
      shirtStyle,
      track,
      country,
      city,
      zone,
      address,
      shirtColor,
      size,
      quantity,
      text,
      textColor,
      font,
      designType,
      image,
      cost,
      totalCost,
      sub,
      shipping,
      sellerId,
      sellerf,
      sellerl,
      sellerEm,
      sellerNumb,
      shape,
      ss;
  _OrderHistoryExtendState(
      this.orderId,
      this.firstname,
      this.lastname,
      this.date,
      this.printType,
      this.textType,
      this.shirtStyle,
      this.track,
      this.address,
      this.country,
      this.city,
      this.zone,
      this.shirtColor,
      this.size,
      this.quantity,
      this.text,
      this.textColor,
      this.font,
      this.designType,
      this.image,
      this.cost,
      this.totalCost,
      this.sub,
      this.shipping,
      this.sellerId,
      this.sellerf,
      this.sellerl,
      this.sellerEm,
      this.sellerNumb,
      this.shape,
      this.ss);

  int random() {
    var rng = Random();
    int a;
    for (var i = 0; i < 10; i++) {
      a = rng.nextInt(100000000);
    }
    return a;
  }

  String customerEmail,customerid;
  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    var userID = prefs.getString("userID");
    setState(() {
      customerEmail = email;
      customerid = userID;
    });
  }

  @override
  void initState() {
    super.initState();
    myPrefs();
  }

  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: showLoader,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text("Order Detail", style: heading2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(
                      thickness: 2,
                      color: themeshirtbg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Seller Detail", style: heading3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Seller Name: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          sellerf + " " + sellerl,
                          softWrap: true,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                            color: Colors.green[300],
                            onPressed: () async {
                              setState(() {
                                showLoader = true;
                              });
                              int randomNumber = random();
                              // setting signed in user document and email in it
                              await _firestore
                                  .collection('Users')
                                  .document(customerEmail)
                                  .setData({
                                'email': customerEmail,
                                'name': firstname,
                              });
                              // placing chat id in signin user
                              await _firestore
                                  .collection('Users')
                                  .document(customerEmail)
                                  .collection('chats')
                                  .document(
                                      '$customerEmail-$randomNumber-$sellerEm')
                                  .setData({
                                'chat_id':
                                    '$customerEmail-$randomNumber-$sellerEm',
                                'chat_with': sellerEm,
                                'chat_with_name': sellerf,
                                'chat_with_id': sellerId,
                                'chat_with_user_type': 'seller',
                              });
                              // creating chat in chats collection
                              await _firestore
                                  .collection('Chats')
                                  .document(
                                      '$customerEmail-$randomNumber-$sellerEm')
                                  .setData({
                                'id': '$customerEmail-$randomNumber-$sellerEm',
                              });
                              // storing members in chat
                              await _firestore
                                  .collection('Chats')
                                  .document(
                                      '$customerEmail-$randomNumber-$sellerEm')
                                  .collection('members')
                                  .add({
                                '1': customerEmail,
                                '2': sellerEm,
                              });
                              // setting target user document and email in it
                              await _firestore
                                  .collection('Users')
                                  .document(sellerEm)
                                  .setData({
                                'email': sellerEm,
                                'name': sellerf,
                              });
                              // placing chat id id in target user
                              await _firestore
                                  .collection('Users')
                                  .document(sellerEm)
                                  .collection('chats')
                                  .document(
                                      '$customerEmail-$randomNumber-$sellerEm')
                                  .setData({
                                'chat_id':
                                    '$customerEmail-$randomNumber-$sellerEm',
                                'chat_with': customerEmail,
                                'chat_with_name': firstname,
                                'chat_with_id': customerid,
                                'chat_with_user_type': 'buyer',
                              });
                              setState(() {
                                showLoader = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userEmail: customerEmail,
                                    userID: customerid,
                                    userType: 'buyer',
                                    chatID: '$customerEmail-$randomNumber-$sellerEm',
                                    targetEmail: sellerEm,
                                    targetID: sellerId,
                                    targetUserType: 'seller',
                                  ),
                                ),
                              );
                            },
                            child: Text("Contact here", style: buttonText))
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text("Seller Email: ",
                  //           style: TextStyle(
                  //               fontSize: 13, fontWeight: FontWeight.bold)),
                  //       Text(
                  //         sellerEm,
                  //         softWrap: true,
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text("Seller Phone: ",
                  //           style: TextStyle(
                  //               fontSize: 13, fontWeight: FontWeight.bold)),
                  //       Text(
                  //         sellerNumb,
                  //         softWrap: true,
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(
                      thickness: 2,
                      color: themeshirtbg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Item Detail", style: heading3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          child: ss.length > 0
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Container(
                                            height: 300,
                                            child: CacheImage(
                                                ("$value/order_image/" + ss),
                                                300)),
                                      ),
                                    );
                                  },
                                  child: CacheImage(
                                      ("$value/order_image/" + ss), 120))
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:
                                      Center(child: Icon(Icons.broken_image)),
                                ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("T-Shirt Color: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                shirtColor,
                                softWrap: true,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("T-Shirt Size: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                size,
                                softWrap: true,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Print Type: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: designType == "Both"
                                    ? Text(
                                        designType + "- Front and Back",
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14),
                                      )
                                    : Text(
                                        designType,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14),
                                      ),
                              ),
                            ],
                          ),
                          Container(
                            child: text.length > 0
                                ? Row(
                                    children: <Widget>[
                                      Text("Custom Text: ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        text,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Container(
                            child: text.length > 0
                                ? Row(
                                    children: <Widget>[
                                      Text("Text Color: ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        textColor,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Container(
                            child: text.length > 0
                                ? Row(
                                    children: <Widget>[
                                      Text("Text Style: ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        shirtStyle,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Container(
                            child: text.length > 0
                                ? Row(
                                    children: <Widget>[
                                      Text("Font Type: ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        font,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Divider(
                      thickness: 2,
                      color: themeshirtbg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Status",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Container(
                          child: track == "Complete"
                              ? Text(track.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[600]))
                              : Text(track.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[600])),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Divider(
                      thickness: 2,
                      color: themeshirtbg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Amount Calculation", style: heading3),
                  ),
                ],
              )),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Sub Total ($cost * $quantity ):",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text("\$" + sub, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Shipping Charges: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(shipping, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Divider(
                              thickness: 2,
                              color: Colors.green[500],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Total Cost:  ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: themeshirt),
                              ),
                              Text("\$" + totalCost.toString(),
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeshirt,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // OrderHistoryTotal(orderId),

                    Divider(
                      thickness: 5,
                      color: Colors.black,
                      indent: 13,
                      endIndent: 13,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Shipping Address",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeshirt),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                  address +
                                      "\n" +
                                      country +
                                      " , " +
                                      city +
                                      " , " +
                                      zone,
                                  softWrap: true)),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
