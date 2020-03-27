import 'package:flutter/material.dart';
import 'package:beautylens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:beautylens/user.dart';
import 'package:beautylens/main_menu.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white70,
                  contentPadding: EdgeInsets.all(20),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  children: <Widget>[
                    Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingRotating.square(
                              borderColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[300],
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Please Wait....",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16.0,
                              ),
                            )
                          ]),
                    )
                  ]));
        });
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  double screenHeight;
  double screenWidth;
  bool _showPassword = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String urlLogin = "http://hackanana.com/beautylens/php/login.php";
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Padding(
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
                color: Colors.indigo[200],
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
                    Colors.indigo[200],
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
              controller: emailController,
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
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintText: 'Password',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                    value: rememberMe,
                    activeColor: Colors.indigo[200],
                    onChanged: (bool value) {
                      _rememberMe(value);
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
              onPressed: _login,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
              color: Colors.indigo[200],
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
                        builder: (BuildContext context) => RegisterScreen())));
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
                  'Forget Password?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.indigo,
                      decoration: TextDecoration.underline),
                ),
              ),
              onPressed: _forgotPassword,
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    String email = emailController.text;
    String password = passwordController.text;
    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success login") {
        print('yes1');
        User _user = new User(
          name: userdata[1],
          email: email,
          password: password,
          phone: userdata[3],
          //credit: userdata[4],
          // datereg: userdata[5]
        );
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Login Success',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 3, milliseconds: 500),
                pageBuilder: (c, d, e) => MainMenu(
                      user: _user,
                    )));
      } else
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent[100],
            content: Text(
              'Login Failed',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
    }).catchError((err) {
      print(err);
    });
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your Email",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                TextField(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print('sent email');
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _rememberMe(bool value) => setState(() {
        rememberMe = value;
        print(rememberMe);
        if (rememberMe) {
          _saveUser(true);
        } else {
          _saveUser(false);
        }
      });

  void loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    if (email.length > 1) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        rememberMe = true;
      });
    }
  }

  void _saveUser(bool value) async {
    String email = emailController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', password);
      setState(() {
        emailController.text = '';
        passwordController.text = '';
        rememberMe = false;
      });
    }
  }
}
