import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class VendorDataDetail extends StatefulWidget {
  final String sellerId, first, last, stock, rating, review, shop, locat, desc;
  VendorDataDetail(this.sellerId, this.first, this.last, this.stock,
      this.rating, this.review, this.shop, this.locat, this.desc);
  @override
  _VendorDataDetailState createState() => _VendorDataDetailState(
      sellerId, first, last, stock, rating, review, shop, locat, desc);
}

class _VendorDataDetailState extends State<VendorDataDetail> {
  final String sellerId, first, last, stock, rating, review, shop, locat, desc;
  _VendorDataDetailState(this.sellerId, this.first, this.last, this.stock,
      this.rating, this.review, this.shop, this.locat, this.desc);
  int size;
  // Future<List<GetSample>> _fetchVendorData() async {
  //   var response = await http.post(getSampleurl, body: {
  //     "id": sellerId,
  //   });
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     List<GetSample> listOfUsers = items.map<GetSample>((json) {
  //       return GetSample.fromJson(json);
  //     }).toList();
  //     size = listOfUsers.length;
  //     return listOfUsers;
  //   } else {
  //     throw Exception('Failed to load internet');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double gap = screenSize.height * 0.4;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    backgroundImage: AssetImage('images/profile.png')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(first + " " + last,),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("$rating "),
                              Text("\($review Reviews\)"),
                              SizedBox(width: 10),
                            ],
                          ),
                          SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: double.parse(rating),
                              size: 20.0,
                              color: Colors.yellow[900],
                              borderColor: Colors.yellow[900],
                              spacing: 0.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 10,
              color: Colors.grey[200],
              thickness: 2,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Container(
                padding: EdgeInsets.only(left: 13),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Shop Name',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$shop',
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 13, top: 13),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Location',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$locat',
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 13, top: 13),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Detail',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 13,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Stock: " + stock),
                    Text('Descripiton: $desc'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 13, top: 13),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Related Samples',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              // FutureBuilder<List<GetSample>>(
              //     future: _fetchVendorData(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData)
              //         return Center(child: CircularProgressIndicator());
              //       if (size == 0) {
              //         return Center(
              //             child: Text(
              //           "--No History Found--",
              //           style: TextStyle(color: Colors.grey),
              //         ));
              //       } else
              //         return Container(
              //             height: 150,
              //             padding: EdgeInsets.only(left: 12),
              //             alignment: Alignment.center,
              //             child: ListView(
              //               scrollDirection: Axis.horizontal,
              //               children: snapshot.data
              //                   .map(
              //                     (sample) => Column(children: <Widget>[
              //                       Padding(
              //                         padding: const EdgeInsets.only(
              //                             right: 8.0, top: 8),
              //                         child: Container(
              //                           color: blackColor,
              //                           child: CacheImage(
              //                               ("$value/images/sample/" +
              //                                   sample.image),
              //                               140),
              //                         ),
              //                       ),
              //                     ]),
              //                   )
              //                   .toList(),
              //             ));
                  // }),
              Container(
                padding: EdgeInsets.only(left: 13, top: 13),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Reviews',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                height: gap,
                // child: SellerRating(rating, review),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
