import 'dart:convert';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/model.dart';
import 'package:bidprint/variables/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class SellerRating extends StatefulWidget {
  final String totalRate, totalReview;
  SellerRating(this.totalRate, this.totalReview);
  @override
  _SellerRatingState createState() =>
      _SellerRatingState(totalRate, totalReview);
}

class _SellerRatingState extends State<SellerRating> {
  String userID;
  int size;
  final String totalRate, totalReview;
  _SellerRatingState(this.totalRate, this.totalReview);
  Future<List<RatingModel>> _fetchReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(ratingurl, body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<RatingModel> listOfUsers = items.map<RatingModel>((json) {
        return RatingModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: TopBar()
            .getAppBar(Icon(Icons.exit_to_app, color: transparent), "", null),
      body: FutureBuilder<List<RatingModel>>(
          future: _fetchReview(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(
            "images/BG.png",
            fit: BoxFit.fill,
          ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: double.parse(totalRate),
                              size: 22.0,
                              color: Colors.yellow[700],
                              borderColor: Colors.yellow[600],
                              spacing: 0.0),
                          Text("  " + totalRate, style: TextStyle(fontSize: 16)),
                          Text(
                            " (" + totalReview + " Reviews)",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                      // color: Colors.grey[100],
                      child:size==0?Center(child: Text("--No Reviews--"),): ListView(
                        children: snapshot.data
                            .map(
                              (review) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(review.customername,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          SmoothStarRating(
                                              allowHalfRating: true,
                                              starCount: 5,
                                              rating: double.parse(review.rate),
                                              size: 20.0,
                                              color: Colors.yellow[700],
                                              borderColor: Colors.yellow[600],
                                              spacing: 0.0),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(child: Text(review.comment))
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(review.date),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ]),
                              ),
                            )
                            .toList(),
                      )),
                ),
              ],
            );
          }),
    );
  }
}
