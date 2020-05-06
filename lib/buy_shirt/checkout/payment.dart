import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_in_app_payments/models.dart';

String chargeServerHost = 'https://us-central1-bidprint.cloudfunctions.net/nonce';
String chargeServerHostSquare = 'https://connect.squareupsandbox.com/v2/payments';
var token = '';

class Payment{
  String errorMessage;
  Payment(this.errorMessage);
}

Future<void> getToken(CardDetails result) async {
  var chargeUrl = "$chargeServerHost";
  var body = jsonEncode({"nonce": result.nonce});
  http.Response response;
  try{
    response = await http.post(chargeUrl, body: body, headers: {
      "content-type": "application/json",
    });
  } on SocketException catch (ex){
    throw Payment(ex.message);
  }
  var responseBody = json.decode(response.body);
  if(response.statusCode == 200){
    token = response.body.replaceRange(0, 1, "");
    token = token.replaceRange(71, 72, "");
    return;
  }else{
    throw Payment(responseBody["errorMessage"]);
  }
}
  // int random() {
  //   var rng = Random();
  //   int a;
  //   for (var i = 0; i < 10; i++) {
  //     a = rng.nextInt(100000000);
  //   }
  //   return a;
  // }
Future<void> chargeCard(CardDetails result,double total, String key) async {
  var chargeUrlSquare = "$chargeServerHostSquare";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String email = prefs.getString('email');
  int cost = (total*100).toInt();
  // cost = cost*100;
  // int randomNumber = random();
  var body = jsonEncode({
    'idempotency_key': key,//'$email.user.$randomNumber', //'e8195462-1bfe-4852-9878-57000130cf88',
    'autocomplete': true,
    'amount_money': {'amount': cost, 'currency': 'USD'},
    'source_id': 'cnon:card-nonce-ok',
    'customer_id': '',
    'delay_capture': false
  });
  http.Response response;
  try{
    response = await http.post(chargeUrlSquare, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
  } on SocketException catch (ex){
    throw Payment(ex.message);
  }
  var responseBody = json.decode(response.body);
  if(response.statusCode == 200){
    return;
  }else{
    throw Payment(responseBody["errorMessage"]);
    
  }
}