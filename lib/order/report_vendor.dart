import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:bidprint/variables/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:bidprint/variables/url.dart';
import 'package:bidprint/variables/widgets.dart';

class ReportTheVendor extends StatefulWidget {
  final String userID, firstname, lastname, orderId, sellerId;
  ReportTheVendor(
      this.userID, this.firstname, this.lastname, this.orderId, this.sellerId);
  @override
  _ReportTheVendorState createState() =>
      _ReportTheVendorState(userID, firstname, lastname, orderId, sellerId);
}

class _ReportTheVendorState extends State<ReportTheVendor> {
  final String userID, firstname, lastname, orderId, sellerId;
  _ReportTheVendorState(
      this.userID, this.firstname, this.lastname, this.orderId, this.sellerId);
  bool _isInAsyncCall = false;
  String name, dropdownValue, comment;
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
                  "Report",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeshirt),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:25.0),
                  child: MyFormField(
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
                      decoration: signForm("Your Name*", null),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                                border: Border.all(color: themeColor),
                                borderRadius: BorderRadius.circular(18),
                              ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      
                      isExpanded: true,
                      hint: Text(
                        "--SELECT--",
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          print(dropdownValue);
                        });
                      },
                      items: <String>[
                        'My item hasn\'nt arrived on time',
                        'I received a damaged item',
                        'I want to return my item',
                        'They don\'t intend to complete the sale',
                        'They sent threatening messages or used abusive or vulgar language',
                        'The seller has provided you with false contact information',
                        'They offer to sell you a listed item outside of our app',
                        'Others',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
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
                    decoration: signForm("Write a message..", null),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: AccountButton(() async {
                    if (name == null || comment == null || dropdownValue==null) {
                      validation(
                          'Note:', "Please provide all the values..", context);
                    } else if (comment.length <= 2) {
                      validation('Note:', "Please enter a valid data..", context);
                    } else {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        print("$name $comment");
                        writeReview();
                      } else {
                        validation(
                            'Failed:',
                            "Try again later or Check your network Connection..",
                            context);
                      }
                    }
                  }, "Send", themeColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("We take all reports seriously, but please make sure your claims are accurate. Learn more about our terms & conditions",
                  softWrap: true,),
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

      var response = await http.post(reporVendorturl, body: {
        "customerId": userID.toString(),
        "orderId": orderId.toString(),
        "sellerId": sellerId.toString(),
        "name": name,
        "title":dropdownValue,
        "comment": comment,
      });
      if (response.statusCode == 200) {
        Navigator.pop(context);
        myToast("Your report has been submitted successfully, we will get back to you soon");
        setState(() {
          _isInAsyncCall = false;
        });
      
    }
  }
}
