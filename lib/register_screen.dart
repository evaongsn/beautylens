import 'package:flutter/material.dart';
import 'package:beautylens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gradient_text/gradient_text.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isChecked = false;
  bool _showPassword = false;
  double screenHeight;
  double screenWidth;
  String urlRegister = "http://hackanana.com/beautylens/php/register.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.lightBlueAccent[100],
      ),
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Image(
                  image: AssetImage('assets/images/contact-lens.png'),
                  alignment: Alignment.center,
                  height: 80,
                  width: 80,
                  color: Colors.blueAccent[100],
                ),
                GradientText(
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
                // Divider(height: 10,
                // thickness: 5,
                // color: Colors.blueGrey[100],),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Register',
                      style: TextStyle(
                          fontSize: 40,
                          //fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ),

                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _nameEditingController,
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    // errorText: _emailValided(_emailEditingController.text)
                    //     ? null
                    //     : 'Email not match',
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
                  height: 5,
                ),
                TextFormField(
                  controller: _passEditingController,
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
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
                  obscureText: !_showPassword,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _phoneEditingController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    // errorText: _phoneValided(_phoneEditingController.text)
                    //     ? null
                    //     : 'Invalid Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintText: 'Phone',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    GestureDetector(
                      onTap: _showEULA,
                      child: Text('I Agree to Terms',
                          style: TextStyle(
                              color: Colors.blue[600],
                              decoration: TextDecoration.underline,
                              fontSize: 14)),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: _onRegister,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 135),
                  color: Colors.lightBlueAccent[100],
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
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        (PageRouteBuilder(
                            transitionDuration:
                                Duration(seconds: 3, milliseconds: 500),
                            pageBuilder: (c, d, e) => LoginScreen())));
                  },
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
                  color: Colors.blueGrey[50],
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
              ],
            ),
          ),
      ),
    );
  }

  bool _emailValided(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  bool _phoneValided(String phoneNumber) {
    return RegExp(r"^(?:[+0]9)?[0-9]{10,11}$").hasMatch(phoneNumber);
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;

    if (!_isChecked) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Read and Agree to our Terms.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Fill in All Information',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (!_emailValided(email)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Invalid Email',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    } else if (!_phoneValided(phone)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Invalid Phone Number',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    } else {
      showAlert(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation Registration.'),
              content: Text("Are You Sure Want To Proceed Registration ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("YES"),
                  onPressed: () => _onPressed(),
                ),
                FlatButton(
                  child: Text("NO"),
                  onPressed: () {
                    //Put your code here which you want to execute on No button click.
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("LOGIN"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
                  },
                ),
              ],
            );
          },
        );
      }

      showAlert(context);
    }
  }

  void _onPressed() {
    Navigator.of(context).pop();
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Registration Success',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent[100],
            content: Text(
              'Registration Failed',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Slumberjer This EULA agreement governs your acquisition and use of our MY.GROCERY software (Software) directly from Slumberjer or indirectly through a Slumberjer authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MY.GROCERY software. It provides a license to use the MY.GROCERY software and contains warranty information and liability disclaimers. If you register for a free trial of the MY.GROCERY software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY.GROCERY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Slumberjer herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY.GROCERY. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Slumberjer. Slumberjer reserves the right to grant licences to use the Software to third parties")),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
