import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beautylens/profile_screen.dart';
import 'package:http/http.dart' as http;

class CreditScreen extends StatefulWidget {
  final User user;
  final String value;
  CreditScreen({this.user, this.value});

  @override
  _CreditScreenState createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshCredit();
    print('credit' + widget.user.credit);
  }

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
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  Duration(seconds: 3, milliseconds: 500),
                              pageBuilder: (c, d, e) => ProfileScreen(
                                  user: widget.user,
                                  onRefresh: _refreshCredit)));
                    }),
                SizedBox(
                  width: 85,
                ),
                Text(
                  'Buy Credit',
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
                    'http://hackanana.com/beautylens/php/buy_credit.php?email=' +
                        widget.user.email +
                        '&phone=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.value +
                        '&current_credit=' +
                        widget.user.credit,
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

  void _refreshCredit() async {
    String credit;
    String urlLoadJobs =
        "https://hackanana.com/beautylens/php/refresh_credit.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        setState(() {
          credit = res.body;
          widget.user.credit = credit;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
