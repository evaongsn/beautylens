import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_text/gradient_text.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkBoxValue = false;
  double screenHeight;
  double screenWidth;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String urlLogin = "http://hackanana.com/beautylens/php/login.php";
  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    // loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Hero(
                tag: 'eyes',
                child: Image(
                  image: AssetImage('assets/images/contact-lens.png'),
                  alignment: Alignment.center,
                  height: 80,
                  width: 80,
                  color: Colors.blueAccent[100],
                ),
              ),
              Hero(
                tag: 'name',
                child: Material(
                  color: Color(0x00000000),
                  child: GradientText(
                    "Beauty Lens",
                    gradient: LinearGradient(colors: [
                      Colors.deepPurple[100],
                      Colors.blueAccent[100],
                      Colors.pink[100]
                    ]),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bellota',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Log In',
                    style: TextStyle(
                        fontSize: 40,
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins')),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: 'Email',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: 'Password',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      value: checkBoxValue,
                      activeColor: Colors.blueAccent[100],
                      onChanged: (bool newValue) {
                        setState(() {
                          checkBoxValue = newValue;
                        });
                      }),
                  Text(
                    'Remember me',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen())));
                },
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
                color: Colors.lightBlueAccent[100],
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RegisterScreen())));
                },
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 135),
                color: Colors.blueGrey[50],
                child: Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              FlatButton(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forget Password',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
