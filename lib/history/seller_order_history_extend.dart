import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:bidprint/variables/dialogue.dart';
import 'package:http/http.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/chat/chat_screen.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:save_in_gallery/save_in_gallery.dart';

final Firestore _firestore = Firestore.instance;

class SellerOrderHistoryExtend extends StatefulWidget {
  final String orderId,
      customerId,
      firstname,
      lastname,
      email,
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
      clipart,
      ss;
  SellerOrderHistoryExtend(
      this.orderId,
      this.customerId,
      this.firstname,
      this.lastname,
      this.email,
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
      this.clipart,
      this.ss);
  @override
  _SellerOrderHistoryExtendState createState() =>
      _SellerOrderHistoryExtendState(
          orderId,
          customerId,
          firstname,
          lastname,
          email,
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
          clipart,
          ss);
}

class _SellerOrderHistoryExtendState extends State<SellerOrderHistoryExtend> {
  final String orderId,
      customerId,
      firstname,
      lastname,
      email,
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
      clipart,
      ss;
  _SellerOrderHistoryExtendState(
      this.orderId,
      this.customerId,
      this.firstname,
      this.lastname,
      this.email,
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
      this.clipart,
      this.ss);
  final _imageSaver = ImageSaver();

  int random() {
    var rng = Random();
    int a;
    for (var i = 0; i < 10; i++) {
      a = rng.nextInt(100000000);
    }
    return a;
  }

  bool showLoader = false;
  // bool _showResult = false;
  // String _resultText = "";
  // Color _resultColor = Colors.red;
  int size2;
  String _mySelection;
  Future<List<OrderStatus>> _fetchStatus() async {
    var response = await http.post(orderStatusurl);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<OrderStatus> listOfUsers = items.map<OrderStatus>((json) {
        return OrderStatus.fromJson(json);
      }).toList();
      size2 = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<void> sendNotification(String title, String body, String orderID, String topic) async {
    final response = await Messaging.sendTo(
      title: title,
      body: body,
      orderID: orderID,
      topic: topic,
    );

    if (response.statusCode != 200) {
      validation(
          "Something Went Wrong",
          "Message was delivered Successfully but notification cannot be sent.",
          context);
    }
  }

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
                    child: Text("Customer Detail", style: heading3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Customer Name: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          firstname + " " + lastname,
                          softWrap: true,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text("Customer Email: ",
                  //           style: TextStyle(
                  //               fontSize: 13, fontWeight: FontWeight.bold)),
                  //       Text(
                  //         email,
                  //         softWrap: true,
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                                  .document(sellerEm)
                                  .setData({
                                'email': sellerEm,
                                'name': sellerf,
                              });
                              // placing chat id in signin user
                              await _firestore
                                  .collection('Users')
                                  .document(sellerEm)
                                  .collection('chats')
                                  .document('$sellerEm-$randomNumber-$email')
                                  .setData({
                                'chat_id': '$sellerEm-$randomNumber-$email',
                                'chat_with': email,
                                'chat_with_name': firstname,
                                'chat_with_id': customerId,
                                'chat_with_user_type': 'buyer',
                              });
                              // creating chat in chats collection
                              await _firestore
                                  .collection('Chats')
                                  .document('$sellerEm-$randomNumber-$email')
                                  .setData({
                                'id': '$sellerEm-$randomNumber-$email',
                              });
                              // storing members in chat
                              await _firestore
                                  .collection('Chats')
                                  .document('$sellerEm-$randomNumber-$email')
                                  .collection('members')
                                  .add({
                                '1': sellerEm,
                                '2': email,
                              });
                              // setting target user document and email in it
                              await _firestore
                                  .collection('Users')
                                  .document(email)
                                  .setData({
                                'email': email,
                                'name': firstname,
                              });
                              // placing chat id id in target user
                              await _firestore
                                  .collection('Users')
                                  .document(email)
                                  .collection('chats')
                                  .document('$sellerEm-$randomNumber-$email')
                                  .setData({
                                'chat_id': '$sellerEm-$randomNumber-$email',
                                'chat_with': sellerEm,
                                'chat_with_name': sellerf,
                                'chat_with_id': sellerId,
                                'chat_with_user_type': 'seller',
                              });
                              setState(() {
                                showLoader = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userEmail: sellerEm,
                                    userID: sellerId,
                                    userType: 'seller',
                                    chatID: '$sellerEm-$randomNumber-$email',
                                    targetEmail: email,
                                    targetID: customerId,
                                    targetUserType: 'buyer',
                                  ),
                                ),
                              );
                            },
                            child: Text("Contact here", style: buttonText))
                      ],
                    ),
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
                    child: Text("Item Detail", style: heading3),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text("T-Shirt Color: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          shirtColor,
                          softWrap: true,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text("T-Shirt Size: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          size,
                          softWrap: true,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Print Type: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
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
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
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
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
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
                    padding: const EdgeInsets.only(left: 8.0),
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
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
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
                  Container(
                    child: track == "Complete"
                        ? null
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Divider(
                                  thickness: 2,
                                  color: themeshirtbg,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Status Update", style: heading3),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FutureBuilder<List<OrderStatus>>(
                                      future: _fetchStatus(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Container(
                                              width: 60,
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                isDense: true,
                                                disabledHint: Text(
                                                  "Select",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                items: null,
                                                onChanged: (String value) {},
                                              ));
                                        if (size2 == 0) {
                                          return Center(
                                              child: Text(
                                            "",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ));
                                        } else
                                          return DropdownButton<String>(
                                              isDense: true,
                                              hint: Text(
                                                "Select",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              value: _mySelection,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  _mySelection = newValue;
                                                });
                                                print(_mySelection);
                                              },
                                              items: snapshot.data
                                                  .map((c) =>
                                                      DropdownMenuItem<String>(
                                                          value: c.statusid,
                                                          child: Text(
                                                            c.name,
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )))
                                                  .toList());
                                      }),
                                  RaisedButton(
                                    color: themebottom,
                                    onPressed: () async {
                                      if (_mySelection != null) {
                                        var response = await http
                                            .post(updatestatusurl, body: {
                                          "id": orderId,
                                          "status": _mySelection
                                        });
                                        if (response.statusCode == 200) {
                                          if (_mySelection == "Complete")
                                            sendNotification("Order Completed!", "Your order $orderId has been completed.", orderId, '$customerId-buyer-order');
                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, '/sellerorderHistory');
                                        }
                                      }
                                    },
                                    child: Text("Save", style: buttonText),
                                  )
                                ],
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
                    child: Text("Downloads", style: heading3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Shirt Preview: ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        Container(
                          child: ss.length > 0
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Container(
                                                  height: 400,
                                                  child: CacheImage(
                                                      ("$value/order_image/" +
                                                          ss),
                                                      300)),
                                            ),
                                          );
                                        },
                                        child: CacheImage(
                                            ("$value/order_image/" + ss), 170)),
                                    InkWell(
                                      onTap: () async {
                                        await ImageDownloader.downloadImage(
                                            "$value/order_image/" + ss);
                                        print("$value/order_image/" + ss);
                                        myToast("Downloading..");
                                      },
                                      child: CircleAvatar(
                                          child: Icon(
                                        Icons.file_download,
                                      )),
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:
                                      Center(child: Icon(Icons.broken_image)),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text("Image for printing: ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: image.length > 0
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  child: Container(
                                                      height: 400,
                                                      child: CacheImage(
                                                          ("$value/order_image/" +
                                                              image),
                                                          300)),
                                                ),
                                              );
                                            },
                                            child: CacheImage(
                                                ("$value/order_image/" + image),
                                                120)),
                                        SizedBox(width: 5),
                                        InkWell(
                                          onTap: () async {
                                            await ImageDownloader.downloadImage(
                                                "$value/order_image/" + image);
                                            print(
                                                "$value/order_image/" + image);
                                            myToast("Downloading..");
                                          },
                                          child: CircleAvatar(
                                              child: Icon(
                                            Icons.file_download,
                                          )),
                                        )
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child:
                                          Center(child: Text("--No Image--")),
                                    ),
                            ),
                            Container(
                              child: clipart.length > 0
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  height: 400,
                                                  child: Image.asset(
                                                      "images/shapes/" +
                                                          clipart),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            "images/shapes/" + clipart,
                                            width: 55,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // InkWell(
                                        //   onTap: () async {
                                            
                                            // List<Uint8List> bytesList = [];
                                            // for (final url in urls) {
                                            //
                                            // final urls = [
                                            //   "images/shapes/$clipart"
                                            // ];
                                            // List<Uint8List> bytesList = [];
                                            // for (final url in urls) {
                                        //       final bytes =
                                        //           await rootBundle.load(url);
                                        //       bytesList.add(
                                        //           bytes.buffer.asUint8List());
                                        //     }
                                        //     final res =
                                        //         await _imageSaver.saveImages(
                                        //             imageBytes: bytesList);
                                        //     print(res);
                                        //   },
                                        //   child: CircleAvatar(
                                        //       child: Icon(
                                        //     Icons.file_download,
                                        //   )),
                                        // )
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child:
                                          Center(child: Text("--No ClipArt--")),
                                    ),
                            ),
                          ],
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

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAAEW-rjW8:APA91bGldZxuxerQb-GUbgvhOcptAiASVge5XSNSYo9xuoikV0dnN2oamydATQ6F5D_LOGMuyxV0YdE_WBuOTz2u84-BC4SG8KRybDxl0Y8-MiX_7xPxLG14CTyW2a1_8nvB3wdVBc5F';

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String orderID,
    @required String topic,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          "notification": {"title": "$title", "body": "$body"},
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "body": "$body",
            "title": "$title",
            "for": "ordercomplete",
            "orderID": orderID,
            "topic": topic,
          },
          "to": "/topics/$topic"
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        },
      );
}
