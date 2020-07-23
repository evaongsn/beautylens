import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'main_menu.dart';
import 'package:beautylens/credit_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final Function onRefresh;

  const ProfileScreen({Key key, this.user, this.onRefresh}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    print("profile screen");
    print(widget.user.credit);
    _refreshCredit();
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    parsedDate = DateTime.parse(widget.user.datereg);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
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
                            pageBuilder: (c, d, e) => MainMenu(
                                  user: widget.user,
                                )));
                  },
                ),
                SizedBox(
                  width: 85,
                ),
                Text(
                  'My Profile',
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
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              elevation: 3,
              color: Colors.indigo[100],
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        height: screenHeight / 4.8,
                        width: screenWidth / 3.2,
                        // decoration: new BoxDecoration(
                        //   shape: BoxShape.circle,
                        // ),
                        child: CircleAvatar(
                          //  radius: 100.0,
                          minRadius: 20,
                          maxRadius: 50,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "http://hackanana.com/beautylens/users_images/${widget.user.email}.jpg?",
                            // imageBuilder: (context, imageProvider) => Container(
                            //   width: 80.0,
                            //   height: 80.0,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.rectangle,
                            //     image: DecorationImage(
                            //         image: imageProvider, fit: BoxFit.fill),
                            //   ),
                            // ),
                            placeholder: (context, url) => new SizedBox(
                                height: 10.0,
                                width: 10.0,
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                new Icon(MdiIcons.cameraIris, size: 64.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: changeName,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo[700],
                              )),
                          IconButton(
                              icon: Icon(Icons.edit,
                                  size: 25, color: Colors.indigo[500]),
                              onPressed: changeName),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //  SizedBox(width: 10),
                        Expanded(
                            child: Container(
                          child: Table(
                              border: TableBorder(
                                  horizontalInside: BorderSide(
                                      color: Colors.indigoAccent, width: 0.5)),
                              defaultColumnWidth: FlexColumnWidth(0.5),
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(8),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.mail,
                                            size: 25,
                                            color: Colors.indigo[300]),
                                        onPressed: () {},
                                      ),
                                    ),
                                    // child: Text("Email",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.white))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text(widget.user.email,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.phone_iphone,
                                            size: 25,
                                            color: Colors.indigo[300]),
                                        onPressed: changePhone,
                                      ),
                                    ),
                                  ),
                                  //       child: Text("Phone",
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               color: Colors.white))),
                                  // ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: GestureDetector(
                                        onTap: changePhone,
                                        child: Text(
                                          widget.user.phone,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.indigo[700]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: IconButton(
                                          icon: Icon(Icons.date_range,
                                              size: 25,
                                              color: Colors.indigo[300]),
                                          onPressed: () {}),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text(f.format(parsedDate),
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: IconButton(
                                          icon: Icon(
                                              Icons.account_balance_wallet,
                                              size: 25,
                                              color: Colors.indigo[300]),
                                          onPressed: () {}),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text(widget.user.credit,
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                ]),
                              ]),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              elevation: 3,
              color: Colors.indigo[100],
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Table(
                                border: TableBorder(
                                    horizontalInside: BorderSide(
                                        color: Colors.indigoAccent,
                                        width: 0.5)),
                                defaultColumnWidth: FlexColumnWidth(0.5),
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(8),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(Icons.lock,
                                              size: 25,
                                              color: Colors.indigo[300]),
                                          onPressed: changePassword,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40,
                                        child: GestureDetector(
                                          onTap: changePassword,
                                          child: Text(
                                            'Change Password',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo[700]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(Icons.payment,
                                              size: 25,
                                              color: Colors.indigo[300]),
                                          onPressed: _reloadCredit,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40,
                                        child: GestureDetector(
                                          onTap: _reloadCredit,
                                          child: Text(
                                            'Reload Credit',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo[700]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register Before You Add Picture',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    File _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    if (_image == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Take A Photo First',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      http.post("https://hackanana.com/beautylens/php/upload_user_image.php",
          body: {
            "encoded_string": base64Image,
            "email": widget.user.email,
          }).then((res) {
        print(res.body);
        if (res.body == "Upload Successful") {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent[100],
              content: Text(
                'Upload Successful',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          );
          setState(() {
            DefaultCacheManager().removeFile(
                "http://hackanana.com/beautylens/users_images/${widget.user.email}.jpg?");
            // DefaultCacheManager manager = new DefaultCacheManager();
            // manager.emptyCache();
          });
        } else {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent[100],
              content: Text(
                'Failed',
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
  }

  void changeName() {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register Before You Add Picture',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    if (widget.user.email == "admin@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'You are in admin mode',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
              title: new Text(
                "Change Name?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(
                      Icons.person,
                      color: Colors.indigo[200],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.indigo[200],
                      ),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.indigo[200],
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register First',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    if (name == "" || name == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please fill in your name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post("https://hackanana.com/beautylens/php/update_user_profile.php",
        body: {
          "email": widget.user.email,
          "name": rc.titleCase.toString(),
        }).then((res) {
      if (res.body == "success") {
        setState(() {
          widget.user.name = rc.titleCase;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Sucess',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePassword() {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register First',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    TextEditingController oldpassController = TextEditingController();
    TextEditingController newpassController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
              title: new Text(
                "Change Password?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: oldpassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.indigo[200],
                        ),
                      )),
                  TextField(
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      controller: newpassController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.indigo[200],
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.indigo[200],
                      ),
                    ),
                    onPressed: () => updatePassword(
                        oldpassController.text, newpassController.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.indigo[200],
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String oldpass, String newpass) {
    if (oldpass == "" || newpass == "") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Enter Password',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }

    http.post("https://hackanana.com/beautylens/php/update_user_profile.php",
        body: {
          "email": widget.user.email,
          "oldpassword": oldpass,
          "newpassword": newpass,
        }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = newpass;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Success',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register First',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change Handphone Number?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'New Handphone Number',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.indigo[200],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.indigo[200],
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.indigo[200],
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please enter your new phone number',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    http.post("https://hackanana.com/beautylens/php/update_user_profile.php",
        body: {
          "email": widget.user.email,
          "phone": phone,
        }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Sucess',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          title: new Text(
            "Go to login page?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.indigo[200],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.indigo[200],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          title: new Text(
            "Register a new account",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.indigo[200],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.indigo[200],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reloadCredit() {
    if (widget.user.email == "guest@email.com") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Register Before You Add Credit',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    TextEditingController creditController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Reload Credit?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter RM',
                    icon: Icon(
                      Icons.attach_money,
                      color: Colors.indigo,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.indigo,
                      ),
                    ),
                    onPressed: () =>
                        _buyCredit(creditController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _buyCredit(String credit) {
    print("RM " + credit);
    if (credit.length <= 0) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[100],
          content: Text(
            'Please Enter Correct Amount',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buy store credit RM ' + credit,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CreditScreen(
                              user: widget.user,
                              value: credit,
                            )));
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.indigo,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.indigo,
                ),
              )),
        ],
      ),
    );
  }
}
