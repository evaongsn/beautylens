import 'package:flutter/material.dart';
import "main_menu.dart";
import 'user.dart';
import 'order_history.dart';
import 'package:intl/intl.dart';
import 'package:beautylens/order_his_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchasedHistoryScreen extends StatefulWidget {
  final User user;
  const PurchasedHistoryScreen({Key key, this.user}) : super(key: key);
  @override
  _PurchasedHistoryScreenState createState() => _PurchasedHistoryScreenState();
}

class _PurchasedHistoryScreenState extends State<PurchasedHistoryScreen> {
  List purchasedpaymentList;

  String titlecenter = "Loading Purchased History...";
  final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPurchasedPaymentHistory();
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
                          pageBuilder: (c, d, e) => MainMenu(
                                user: widget.user,
                              )));
                },
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                'Purchased History',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
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
          purchasedpaymentList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount: purchasedpaymentList == null
                          ? 0
                          : purchasedpaymentList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: () => loadOrderHistoryDetails(index),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.indigo[200],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            '  ' + (index + 1).toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      VerticalDivider(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "RM " +
                                                purchasedpaymentList[index]
                                                    ['total'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      VerticalDivider(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Order ID: ' +
                                                    purchasedpaymentList[index]
                                                        ['orderid'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Divider(
                                                color: Colors.black26,
                                                height: 0.5,
                                              ),
                                              Text(
                                                "Bill ID: \n" +
                                                    purchasedpaymentList[index]
                                                        ['billid'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                      VerticalDivider(
                                        width: 1.0,
                                        thickness: 1.0,
                                        color: Colors.black54,
                                      ),
                                      Expanded(
                                        child: Text(
                                          dateFormat.format(DateTime.parse(
                                              purchasedpaymentList[index]
                                                  ['date'])),
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

  Future<void> _loadPurchasedPaymentHistory() async {
    String urlLoadJobs =
        "https://hackanana.com/beautylens/php/load_purchased_payment.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          purchasedpaymentList = null;
          titlecenter = "No Previous Purchase";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          purchasedpaymentList = extractdata["payments"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderHistoryDetails(int index) {
    OrderH orderH = new OrderH(
        orderId: purchasedpaymentList[index]['order_id'],
        billId: purchasedpaymentList[index]['bill_id'],
        total: purchasedpaymentList[index]['total'],
        datePaid: purchasedpaymentList[index]['date']);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderHistoryDetailsScreen(
                  orderH: orderH,
                )));
  }
}
