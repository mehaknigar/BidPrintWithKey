import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/buy_shirt/checkout/payment.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';

class PlaceOrder extends StatefulWidget {
  final String userID, subtotal, totalShip, totalCost;
  final List sellerIDs;
  PlaceOrder(this.userID, this.subtotal, this.totalShip, this.totalCost,this.sellerIDs);
  @override
  _PlaceOrderState createState() =>
      _PlaceOrderState(userID, subtotal, totalShip, totalCost,sellerIDs);
}

class _PlaceOrderState extends State<PlaceOrder> {
  final String userID, subtotal, totalShip, totalCost;
  final List sellerIDs;
  _PlaceOrderState(this.userID, this.subtotal, this.totalShip, this.totalCost,this.sellerIDs);
  FlutterLocalNotificationsPlugin notifications;

  int random() {
    var rng = Random();
    int a;
    for (var i = 0; i < 10; i++) {
      a = rng.nextInt(100000000);
    }
    return a;
  }

  Future<void> sendNotification(String title, String body, String topic) async {
    final response = await Messaging.sendTo(
      title: title,
      body: body,
      topic: '$topic-seller-chat',
    );
  }

  @override
  void initState() {
    super.initState();
    notifications = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    notifications.initialize(initSetttings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar()
          .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              "Payment",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf4511e)),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(top: 40, left: 8, bottom: 5),
            child: Text(
              "You can pay by using following cards:",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: black),
            ),
          ),
          prefix0.Card(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset("images/visacard.png", width: 70),
                Image.asset("images/mastercard.png", width: 70),
                Image.asset("images/amex.png", width: 70),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: themeColor,
                  onPressed: () async {
                    int randomNumber = random();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String email = prefs.getString('email');
                    _payment(randomNumber, email);
                  },
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Pay \$$totalCost ",
                      style: TextStyle(color: skinColor),
                    ),
                  ),
                  icon: Icon(Icons.payment, color: skinColor),
                )),
          ),
        ],
      ),
    );
  }

  _payment(randomNumber, email) async {
    await InAppPayments.setSquareApplicationId('sq0idp-0oO2b7vOtlVNE6IpGna-5Q');
    await InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: (CardDetails result) async {
        try {
          await getToken(result);
          await chargeCard(result, double.parse(totalCost),
              '$email.user.$randomNumber'); //(total.toInt()));
          InAppPayments.completeCardEntry(onCardEntryComplete: () async {
            _placeOrder(randomNumber, email);
          });
        } catch (ex) {
          InAppPayments.showCardNonceProcessingError(ex.toString());
        }
      },
    );
  }

  _placeOrder(randomNumber, email) async {
    var response = await http.post(placeOrderurl,
        body: {"userId": userID, 'id_key': '$email.user.$randomNumber'});

    if (response.statusCode == 200) {
      myToast("your order has been placed successfully..");
      for (var i = 0; i < sellerIDs.length; i++) {
        sendNotification('BidPrint', 'You have new order. Check your orders.', '${sellerIDs[i]}-seller-order');
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      showNotification(
          'You have placed an order, view order history for detail');
    } else {
      myToast("Something went wrong!");
    }
  }

  showNotification(String name) async {
    String nm = name;
    var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max,
      // autoCancel: false, ongoing: true
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await notifications.show(
      0,
      nm,
      'T-Shirt Printing',
      platform,
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
            "for": "orderplaced",
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
