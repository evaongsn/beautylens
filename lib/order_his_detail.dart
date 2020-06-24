import 'package:flutter/material.dart';
import 'order_history.dart';
import 'dart:convert';
import 'user.dart';
import 'purchased_history.dart';
import 'package:http/http.dart' as http;

class OrderHistoryDetailsScreen extends StatefulWidget {
   final OrderH orderH;
   final User user;
  OrderHistoryDetailsScreen({Key key, this.orderH, this.user}) : super(key: key);

  @override
  _OrderHistoryDetailsScreenState createState() => _OrderHistoryDetailsScreenState();
}

class _OrderHistoryDetailsScreenState extends State<OrderHistoryDetailsScreen> {
  List purchasedDetails;
  String titlecenter = "Loading Purchased Details...";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    print('hi');
    _loadPurchasedDetails();
    print("loaded");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //  key: CartScreen.scaffoldKey,
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          SizedBox(
            height: 35,
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    size: 30, color: Colors.indigo[300]),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          transitionDuration:
                              Duration(seconds: 3, milliseconds: 500),
                          pageBuilder: (c, d, e) => PurchasedHistoryScreen(
                                user: widget.user,
                              )));
                },
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Purchased History Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2.0,
            indent: 10.0,
            endIndent: 10.0,
            color: Colors.black,
          ),
          purchasedDetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                     fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          purchasedDetails == null ? 0 : purchasedDetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            (index + 1).toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            purchasedDetails[index]['id'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                purchasedDetails[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                purchasedDetails[index]
                                                    ['cart_quantity'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          purchasedDetails[index]['price'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

   _loadPurchasedDetails() async {
    String urlLoadJobs =
        "http://hackanana.com/beautylens/php/load_purchased_history.php";
    await http.post(urlLoadJobs, body: {
      "order_id": widget.orderH.orderId,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          purchasedDetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          purchasedDetails = extractdata["purchasedhistory"];
          print(purchasedDetails);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}