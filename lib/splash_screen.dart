import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'dart:async';

void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.indigo[200],
        fontFamily: 'Poppins',
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context,
          (PageRouteBuilder(
              transitionDuration: Duration(seconds: 3, milliseconds: 500),
              pageBuilder: (c, d, e) => LoginScreen())));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'eyes',
              child: Image(
                image: AssetImage('assets/images/contact-lens.png'),
                alignment: Alignment.center,
                height: 80,
                width: 80,
                color: Colors.indigo[200],
              ),
            ),
            Hero(
              tag: 'name',
              child: Material(
                color: Color(0x00000000),
                child: ColorizeAnimatedTextKit(
                    speed: Duration(milliseconds: 500),
                    text: [
                      "Beauty Lens",
                    ],
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Bellota',
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Colors.pinkAccent[100],
                      Colors.indigo[200],
                      Colors.indigo[300],
                      Colors.purple[100],
                    ],
                    textAlign: TextAlign.start,
                    alignment:
                        AlignmentDirectional.centerStart // or Alignment.topLeft
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(220, 220, 220, 100),
                valueColor: AlwaysStoppedAnimation(
                  Color(0xFF9FA8DA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
