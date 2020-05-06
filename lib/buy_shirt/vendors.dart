import 'dart:convert';
import 'package:bidprint/account/login.dart';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShowVendors extends StatefulWidget {
  final vendors;
  ShowVendors(this.vendors);
  @override
  _ShowVendorsState createState() => _ShowVendorsState(vendors);
}

class _ShowVendorsState extends State<ShowVendors> {
  final vendors;
  _ShowVendorsState(this.vendors);
  int size;
  Future<List<GetVendorsList>> _fetchVendors() async {
    if (vendors.length > 0) {
      final items = (vendors).cast<Map<String, dynamic>>();
      List<GetVendorsList> listOfUsers = items.map<GetVendorsList>((json) {
        return GetVendorsList.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  String user;

  _prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("user");
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => Login("buyer"))));
    } else if (user == "buyer") {
      Navigator.pushNamed(context, "/cart");
    }
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
        appBar: TopBar().getAppBar(
            Icon(Icons.shopping_cart), "Select Supplier".toUpperCase(), () {
          _prefs();
        }),
        body: FutureBuilder<List<GetVendorsList>>(
          future: _fetchVendors(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text(
                  "--No Supplier Found, Try With Another Features--",
                  style: TextStyle(color: Colors.grey),
                ),
              );

            return Container(
              child: ListView(
                children: snapshot.data
                    .map(
                      (vend) => Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color:themeshirtbg),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CircleAvatar(
                                      child: Text(vend.first[0].toUpperCase(),style: buttonText,),
                                      minRadius: 25,
                                      backgroundColor: themeshirtbg,
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        vend.first + " " + vend.last,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20),
                                      ),
                                    
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            vend.rating,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            " \(" + vend.review + " Reviews\)",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  OutlineButton(
                                    borderSide: BorderSide(color: themebutton),
                                    onPressed: () {
                                      addShipping(vend.weight,
                                          vend.sellerid,vend.address,vend.city,vend.post,vend.country,vend.zone,
                                          vend.color,
                                          vend.size,
                                          vend.customText,
                                          vend.textColor,
                                          vend.font,
                                          vend.designType,
                                          vend.printType,
                                          vend.shirtStyle,
                                          vend.textType,
                                          vend.cost,
                                          vend.piece,
                                          vend.totalCost,
                                          vend.image,
                                          vend.imageName,vend.shape,vend.ssName,vend.ssImage);
                                    },
                                    child: Text("Add to Cart",
                                        style: TextStyle(
                                            color: themebutton,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 15),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "\$" + vend.cost,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      " x " + vend.piece + " = ",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "\$" + vend.totalCost,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  _addToCart(
      sellerid,address,city,post,country,zone,
      shirtColor,
      shirtSize,
      customText,
      textColor,
      font,
      designType,
      printType,
      shirtStyle,
      textType,
      cost,
      piece,weight,
      totalCost,
      image,
      imageName,shape,ssName,ssImage) async {
    double total =  double.parse( totalCost)+(getShippingRates);
    print(total);
    print("$sellerid,$address,$city,$post,$country,$zone, $shirtColor,$shirtSize, $customText,$textColor");
    print("$font,$designType,$printType,$shirtStyle,$textType,$cost,$piece,$weight");
    print("$totalCost,$image,$imageName");
    print("$shape,$ssName,$ssImage");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    if (userID == null) {
      return null;
    } else { 
      var response = await http.post(orderDetailurl, body: {
        "userId": userID,
        "sellerId": sellerid,
        "address": address,
        "city":city,
        "post":post,
        "country":country,
        "zone":zone,
        "color": shirtColor,
        "size": shirtSize,
        "customText": customText.length > 0 ? customText : '',
        "textColor": customText.length > 0 ? textColor : '',
        "font": customText.length > 0 ? font : '',
        "design_type": designType,
        "printType": printType,
        "shirt_style": shirtStyle,
        "text_type": customText.length > 0 ? textType : '',
        "cost": cost,
        "quantity": piece,
        "totalCost": totalCost,
        "weight": weight,
        "image": image.length > 0 ? image : '',
        "imageName": image.length > 0 ? imageName : '',
        "shape": shape.length > 0? shape : '',
        "ssName":ssName,
        "ssImage":ssImage,
        "shipping": (getShippingRates).toStringAsFixed(2),
        "total": total.toStringAsFixed(2),
      });
 setState(() {
      _isInAsyncCall = false;
    });
      if (response.statusCode == 200) {
        
        Fluttertoast.showToast(
            msg: "Product added to cart successfully..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
bool _isInAsyncCall = false;
   Map<String, dynamic> rates = {};
Future addShipping(weight,sellerid,address,city,post,country,zone,
      shirtColor,
      shirtSize,
      customText,
      textColor,
      font,
      designType,
      printType,
      shirtStyle,
      textType,
      cost,
      piece,
      totalCost,
      image,
      imageName,shape,ssName,ssImage) async {
        print(weight);
     double  totalweight = double.parse( weight)*int.parse(piece);
     print(totalweight);
            setState(() {
      _isInAsyncCall = true;
    });
    var headers = {'charset': 'utf-8'};
    var url = "https://wwwcie.ups.com/rest/Rate";
    var request = {
      "UPSSecurity": {
        "UsernameToken": {"Username": "salterz1", "Password": "7lUNulS#"},
        "ServiceAccessToken": {"AccessLicenseNumber": "0D70375730F7D076"}
      },
      "RateRequest": {
        "Request": {
          "RequestOption": "Rate",
          "TransactionReference": {"CustomerContext": "Your Customer Context"}
        },
        "Shipment": {
          "Shipper": {
            "Name": "Shipper Name",
            "ShipperNumber": "Shipper Number",
            "Address": {
              "AddressLine": ["SVCables", "216 Lindbergh Ave"],
              "City": "Livermore",
              "StateProvinceCode": "CA",
              "PostalCode": "94551",
              "CountryCode": "US"
            }
          },
          "ShipTo": {
            "Name": "Ship To Name",
            "Address": {"PostalCode": "90201", "CountryCode": "US"}
          },
          "ShipFrom": {
            "Name": "Ship From Name",
            "Address": {
              "AddressLine": ["SVCables", "216 Lindbergh Ave"],
              "City": "Livermore",
              "StateProvinceCode": "CA",
              "PostalCode": "94551",
              "CountryCode": "US"
            }
          },
          "Service": {"Code": "02", "Description": "Service Code Description"},
          "Package": {
            "PackagingType": {"Code": "02", "Description": "Rate"},
            "PackageWeight": {
              "UnitOfMeasurement": {"Code": "Lbs", "Description": "pounds"},
              "Weight": totalweight.toString(),
            }
          },
          "ShipmentRatingOptions": {"NegotiatedRatesIndicator": ""}
        }
      }
    };

    var response =
        await http.post(url, body: json.encode(request), headers: headers);

    setState(() {
      rates = json.decode(response.body);
      _addToCart(sellerid,address,city,post,country,zone, shirtColor, shirtSize, customText, textColor, font, designType, printType, shirtStyle, textType, cost, piece, totalweight.toString(), totalCost, image, imageName,shape,ssName,ssImage);
    });
  }

  get getShippingRates {
    return double.parse(rates['RateResponse']['RatedShipment']['TotalCharges']['MonetaryValue']);
  }
}
