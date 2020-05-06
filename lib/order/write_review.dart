import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';

class WritReview extends StatefulWidget {
 final String userID, firstname, lastname, orderId, sellerId;
  WritReview(  this.userID, this.firstname, this.lastname, this.orderId, this.sellerId);
  @override
  _WritReviewState createState() => _WritReviewState(userID, firstname, lastname, orderId, sellerId);
}

class _WritReviewState extends State<WritReview> {
 final String userID, firstname, lastname, orderId, sellerId;
  _WritReviewState( this.userID, this.firstname, this.lastname, this.orderId, this.sellerId);
  double rating = 0.0;
  bool _isInAsyncCall = false;
  String name, comment;
  TextEditingController _controller;
  myPrefs() async {
    setState(() {
      _controller = new TextEditingController(text: firstname + " " + lastname);
      name = firstname + " " + lastname;
      print(name);
    });
  }

  @override
  void initState() {
    super.initState();
    myPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.4,
        color: skinColor,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Form(
            child: Column(
              children: <Widget>[
                Text(
                  "Write A Review",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeshirt),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SmoothStarRating(
                      allowHalfRating: true,
                      onRatingChanged: (v) {
                        rating = v;
                        setState(() {});
                      },
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      color: Colors.yellow[700],
                      borderColor: Colors.yellow[600],
                      spacing: 0.0),
                ),
                Text(
                 "Rate  "+ rating.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                MyFormField(
                  45,
                  TextFormField(
                    readOnly: true,
                    controller: _controller,
                    onChanged: (value) {
                      name = value;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    decoration: signForm("Your Name*",null),
                  ),
                ),
                MyFormField(
                  90,
                  TextFormField(
                    maxLines: 3,
                    onChanged: (value) {
                      comment = value;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    decoration: signForm("Write a Comment..",null),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: AccountButton(() async {
                    if (name == null || comment == null || rating == 0.0) {
                      validation('Note:', "Please provide all the values..",context);
                    } else if ( comment.length <= 2) {
                      validation('Note:', "Please enter a valid data..",context);
                    } else {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        print("$name $comment");
                        writeReview();
                      } else {
                        validation('Failed:',
                            "Try again later or Check your network Connection..",context);
                      }
                    }
                  }, "Submit", themeColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  writeReview() async {
    setState(() {
      _isInAsyncCall = true;
    });
 
      var response = await http.post(writeReviewturl, body: {
        "customerId": userID.toString(),
        "orderId": orderId.toString(),
        "sellerId": sellerId.toString(),
        "name": name,
        "comment": comment,
        "rating": rating.toString()
      });
      if (response.statusCode == 200) {
        myToast("Thank you for your reviews, This matters a lot for us");
        Navigator.pop(context);
        setState(() {
          _isInAsyncCall = false;
        });
        rating=0;
      }
    }
  

}
