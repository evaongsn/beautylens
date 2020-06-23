import 'package:beautylens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderId, value;
  PaymentScreen({this.user, this.orderId, this.value});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //    navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.indigo[200],
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                            pageBuilder: (c, d, e) => CartScreen(
                                  user: widget.user,
                                  
                                ))
                      
                        );
                        }
                ),
                SizedBox(
                  width: 85,
                ),
                Text(
                  'Payment',
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: WebView( 
                initialUrl:
                    'http://hackanana.com/beautylens/php/payment.php?email=' +
                        widget.user.email +
                        '&phone=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.value +
                        '&order_id=' +
                        widget.orderId,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
