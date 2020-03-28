import 'package:flutter/material.dart';
import 'package:beautylens/user.dart';
import 'package:beautylens/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainMenu extends StatefulWidget {
  final User user;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  const MainMenu({Key key, this.user}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List products = [];
  int curNum = 1;
  double screenHeight, screenWidth;

  bool visible = false;
  bool visibleSearch = false;
  String curType = "Recent";
  String cartQuantity = '0';
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  //  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController productController = new TextEditingController();
    if (products == null) {
      return MaterialApp(
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
                height: 45,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu, size: 30, color: Colors.indigo[300]),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 85,
                  ),
                  Text(
                    'Products',
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
                height: 250,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.indigo,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading Products",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.indigo[200],
        ),
        home: Scaffold(
          key: MainMenu.scaffoldKey,
          drawer: mainDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 45,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu, size: 30, color: Colors.indigo[300]),
                    onPressed: () =>
                        MainMenu.scaffoldKey.currentState.openDrawer(),
                  ),
                  SizedBox(width: 80),
                  Text(
                    'Products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: 40),
                  IconButton(
                    icon: visibleSearch
                        ? new Icon(Icons.search)
                        : new Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        if (visibleSearch) {
                          visibleSearch = false;
                        } else {
                          visibleSearch = true;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: visible
                        ? new Icon(Icons.expand_more)
                        : new Icon(Icons.expand_less),
                    onPressed: () {
                      setState(() {
                        if (visible) {
                          visible = false;
                        } else {
                          visible = true;
                        }
                      });
                    },
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
                indent: 10.0,
                endIndent: 10.0,
                color: Colors.black,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: visible,
                      child: Card(
                        color: Colors.indigo[200],
                        elevation: 10,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              FlatButton(
                                onPressed: () => sortProducts("Recent"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100.0, vertical: 0.0),
                                child: Text(
                                  "Recent",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.black87,
                              ),
                              FlatButton(
                                onPressed: () =>
                                    sortProducts("Brilliant Colored"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 0.0),
                                child: Text(
                                  "Brilliant Colored",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.black87,
                              ),
                              FlatButton(
                                onPressed: () => sortProducts("Mochi"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100.0, vertical: 0.0),
                                child: Text(
                                  "Mochi",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.black87,
                              ),
                              FlatButton(
                                onPressed: () => sortProducts("Ocean Sky"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100.0, vertical: 0.0),
                                child: Text(
                                  "Ocean Sky",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.black87,
                              ),
                              FlatButton(
                                onPressed: () =>
                                    sortProducts("Seencon World II"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 0.0),
                                child: Text(
                                  "Seencon World II",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibleSearch,
                child: Card(
                  color: Colors.indigo[200],
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: new BorderRadius.circular(5.0)),
                    height: screenHeight / 12,
                    margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: 30,
                            child: TextFormField(
                              autofocus: false,
                              controller: productController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: MaterialButton(
                            color: Colors.indigo[200],
                            onPressed: () =>
                                {sortProductsbySearch(productController.text)},
                            elevation: 5,
                            child: Text(
                              "Search",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                curType,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
                  children: List.generate(
                    products.length,
                    (index) {
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => imageDisplay(index),
                                child: Container(
                                    height: screenWidth / 4,
                                    width: screenWidth / 4,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
                              ),
                              Text(products[index]['name'],
                                  maxLines: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                "RM " + products[index]['price'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Quantity available:" +
                                  products[index]['quantity']),
                              Text("Power:" + products[index]['power']),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                minWidth: 100,
                                height: 40,
                                child: Text('Add to Cart'),
                                color: Colors.blue[500],
                                textColor: Colors.white,
                                elevation: 10,
                              //  onPressed: () => _addtocartdialog(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget mainDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text(
                "RM" + widget.user.credit,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
            currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Colors.white
                        : Colors.white,
                child: Text(
                  widget.user.name.toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 20.0),
                )),
          ),
          ListTile(
            title: Text("Search"),
            trailing: Icon(Icons.search),
          ),
          ListTile(
            title: Text("My Cart"),
            trailing: Icon(Icons.shopping_cart),
          ),
          ListTile(
            title: Text("Purchased History"),
            trailing: Icon(Icons.history),
          ),
          Divider(
            thickness: 2.0,
          ),
          ListTile(
            title: Text("User Profile"),
            trailing: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Log Out"),
            trailing: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }

  void _loadProducts() {
    String urlLoadProducts =
        "http://hackanana.com/beautylens/php/load_products.php";
    http.post(urlLoadProducts, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        products = extractdata["products"];
       // cartQuantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void sortProducts(String type) {
    Dialogs.showLoadingDialog(context, _keyLoader);
    String urlLoadProduct =
        "http://hackanana.com/beautylens/php/load_products.php";
    http.post(urlLoadProduct, body: {
      "type": type,
    }).then((res) {
      setState(() {
        curType = type;
        var extractdata = json.decode(res.body);
        products = extractdata["products"];
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }).catchError((err) {
      print(err);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });

    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  void sortProductsbySearch(String productName) {
    Dialogs.showLoadingDialog(context, _keyLoader);
    print(productName);
    String urlLoadProduct =
        "http://hackanana.com/beautylens/php/load_products.php";
    http.post(urlLoadProduct, body: {
      "name": productName.toString(),
    }).then((res) {
      if (res.body == "nodata") {
        MainMenu.scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent[100],
            content: Text(
              'Product Not Found',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        );
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        FocusScope.of(context).requestFocus(new FocusNode());
        return;
      }
      setState(() {
        var extractdata = json.decode(res.body);
        products = extractdata["products"];
        FocusScope.of(context).requestFocus(new FocusNode());
        curType = productName;
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }).catchError((err) {
      print(err);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });

    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  imageDisplay(int index) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenHeight / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                               "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }
}
