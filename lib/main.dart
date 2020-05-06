import 'package:bidprint/buy_shirt/buy.dart';
import 'package:bidprint/buyer/addAddress.dart';
import 'package:bidprint/buyer/address.dart';
import 'package:bidprint/buyer/buyer_profile.dart';
import 'package:bidprint/buyer/edit_account.dart';
import 'package:bidprint/buyer/edit_password.dart';
import 'package:bidprint/description/about.dart';
import 'package:bidprint/description/shipping_policy.dart';
import 'package:bidprint/description/terms_conditions.dart';
import 'package:bidprint/history/buyer_order_history.dart';
import 'package:bidprint/history/seller_order_history.dart';
import 'package:bidprint/home.dart';
import 'package:bidprint/notifications.dart';
import 'package:bidprint/seller/add_product_features.dart';
import 'package:bidprint/seller/seller_profile/holidaySetting.dart';
import 'package:bidprint/seller/seller_profile/seller_payments.dart';
import 'package:bidprint/seller/seller_profile/seller_profile.dart';
import 'package:bidprint/seller/seller_profile/total_seller_payment.dart';
import 'package:bidprint/splashscreen.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:flutter/material.dart';

import 'buy_shirt/checkout/cart.dart';

void main() => runApp(MyApp());
 final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //  onGenerateRoute: Home(),
      navigatorKey: key,
    home: SplashScreen(),
    
      routes: {
        '/home' : (context) => Home(), 
        '/buyer' : (context) => BuyerDashboard(),
        '/seller' : (context) => SellerProfile(),
        '/buy' : (context) => BuyTShirt(),
        '/editaccount' : (context) => EditAccount(),
        '/address' : (context) => AddAddress(),
        '/addaddress' : (context) => Address(),
        '/cart' : (context) => CartPage(),
        '/orderHistory' :(context) => BuyerOrderHistory(),
        '/sellerorderHistory' :(context) => SellerOrderHistory(),
        '/addproductfeatures' :(context) => AddProductFeatures(),
        '/password': (context)=> Password(),
        '/notification': (context)=> Notifications(),
        '/about': (context) => AboutPage(),
        '/shipPolicy': (context)=> ShippingPolicy(),
        '/terms': (context)=> TermsConditions(),
        '/holiday': (context)=> HolidaySetting(),
        '/sellerPay': (context) => SellerPayments(),
        '/totalsellerPay': (context) => TotalSellerPayments(),
     
      },
      theme: ThemeData(
         primaryColor: themebutton
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
