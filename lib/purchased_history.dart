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
      appBar: AppBar(
        title: Text('Purchased History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Purchased History",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          purchasedpaymentList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,

              

                  style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount: purchasedpaymentList == null ? 0 : purchasedpaymentList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: () => loadOrderHistoryDetails(index),
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
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "RM " +
                                                purchasedpaymentList[index]['total'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                purchasedpaymentList[index]['order_id'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                purchasedpaymentList[index]['bill_id'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          dateFormat.format(DateTime.parse(
                                              purchasedpaymentList[index]['date'])),
                                          style: TextStyle(color: Colors.white),
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
        billId: purchasedpaymentList[index]['bill_id'],
        orderId: purchasedpaymentList[index]['order_id'],
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