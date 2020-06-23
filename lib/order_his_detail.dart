import 'package:flutter/material.dart';
import 'order_history.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderHistoryDetailsScreen extends StatefulWidget {
   final OrderH orderH;
  OrderHistoryDetailsScreen({Key key, this.orderH}) : super(key: key);

  @override
  _OrderHistoryDetailsScreenState createState() => _OrderHistoryDetailsScreenState();
}

class _OrderHistoryDetailsScreenState extends State<OrderHistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: SizedBox(height:100),
    );
  }
}