// import 'package:flutter/gestures.dart';
import 'package:beautylens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:beautylens/user.dart';
import 'package:beautylens/cart_screen.dart';
import 'package:beautylens/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beautylens/purchased_history.dart';
import 'package:beautylens/profile_screen.dart';
import 'package:beautylens/bloc.dart';

class MainMenu extends StatefulWidget {
  final User user;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  const MainMenu({Key key, this.user}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List products = [];
  int curNum = 1;
  double screenHeight, screenWidth;
  int test = 1;

  bool visible = false;
  bool visibleSearch = false;
  String curType = "Recent";
  String cartQuantity;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final navigatorKey = GlobalKey<NavigatorState>();
  NavigationDrawerBloc bloc = NavigationDrawerBloc();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _refreshCartQuantity();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController productController = new TextEditingController();
    if (products == null) {
      return MaterialApp(
        navigatorKey: navigatorKey,
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
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.indigo[200],
        ),
        home: Scaffold(
          key: MainMenu.scaffoldKey,
          drawer: mainDrawer(),
          // body: StreamBuilder(
          //   stream: bloc.getNavigation,
          //   initialData: bloc.navigationProvider.currentNavigation,
          //   builder: (context, snapshot) {
          //     if (bloc.navigationProvider.currentNavigation == "My Cart") {
          //       return CartScreen(user: widget.user,);
          //     }
          //     if (bloc.navigationProvider.currentNavigation ==
          //         "Purchased History") {
          //       return PurchasedHistoryScreen(user: widget.user,);
          //     }
          //     // if (bloc.navigationProvider.currentNavigation == "PageTwo") {
          //     //   return PageTwo();
          //     // }
          //     else {
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu,
                              size: 30, color: Colors.indigo[300]),
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
                                      onPressed: () =>
                                          sortProducts("Ocean Sky"),
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
                                  onPressed: () => {
                                    sortProductsbySearch(productController.text)
                                  },
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
                        //scrollDirection: Axis.horizontal,
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.8,
                        children: List.generate(
                          products.length,
                          (index) {
                            return Card(
                              color: Colors.indigo[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                side: BorderSide(
                                  width: 1,
                                  color: Colors.indigo,
                                ),
                              ),
                              margin: EdgeInsets.all(5),
                              elevation: 6,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () => imageDisplay(index),
                                      child: Container(
                                          height: screenWidth / 5,
                                          width: screenWidth / 3,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  color: Colors.indigo),
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(
                                                      "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(products[index]['name'],
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "RM " + products[index]['price'],
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => viewProductsDetails(index),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "\nClick and View More Details\n",
                                          style: TextStyle(
                                            color: Colors.indigo[300],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ClipOval(
                                        child: Material(
                                          elevation: 20,
                                          color: Colors
                                              .indigo[100], // button color
                                          child: InkWell(
                                            splashColor: Colors.indigo[400],
                                            onTap: () {
                                              addToCartDialog(index);
                                            },
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child:
                                                  Icon(Icons.add_shopping_cart),
                                            ),
                                          ),
                                        ),
                                      ),
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
            //     );
            //   } //else
            // }, //builder
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 5,
            backgroundColor: Colors.indigo[300],
            onPressed: () {
              Navigator.pushReplacement(
                  this.context,
                  PageRouteBuilder(
                      transitionDuration:
                          Duration(seconds: 3, milliseconds: 500),
                      pageBuilder: (c, d, e) => CartScreen(
                          user: widget.user, onRefresh: _refreshCartQuantity)));
            },
            icon: Icon(Icons.shopping_cart),
            label: Text(
              cartQuantity.toString().replaceAll('\n', ''),
            ),
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
                maxLines: 1,
                style: TextStyle(fontSize: 11, color: Colors.white),
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
            onTap: () {
              Navigator.of(context).pop();

              // bloc.updateNavigation("CartScreen");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CartScreen(
                            user: widget.user,
                          )));
            },
            title: Text("My Cart"),
            trailing: Icon(Icons.shopping_cart),
          ),
          ListTile(
            title: Text("Purchased History"),
            trailing: Icon(Icons.history),
            onTap: ()  {
              Navigator.pop(context);
              // bloc.updateNavigation("Purchased History"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PurchasedHistoryScreen(
                            user: widget.user,
                          )));
            },
          ),
          Divider(
            thickness: 2.0,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProfileScreen(user: widget.user)));
            },
            title: Text("User Profile"),
            trailing: Icon(Icons.person),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
            },
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
        cartQuantity = widget.user.quantity;
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
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.redAccent[100],
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
                      border: Border.all(color: Colors.indigo),
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void viewProductsDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.indigo[100],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            content: new Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: screenHeight / 1.4,
              //  color: Colors.white70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 2,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(products[index]['name'],
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "RM " + products[index]['price'] + "\n",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Power: " + products[index]['power']),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Size: " + products[index]['size'] + " mm"),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Type: " + products[index]['type']),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Expiration Time: " +
                        products[index]['expiration_time']),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quantity Available: " +
                        products[index]['quantity'] +
                        " pairs\n"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      elevation: 5,
                      color: Colors.indigo[300], // button color
                      child: InkWell(
                        splashColor: Colors.indigo[400],
                        onTap: () {
                          Navigator.of(context).pop(false);
                          addToCartDialog(index);
                        },
                        child: SizedBox(
                          width: 140,
                          height: 40,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  addToCartDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.indigo[100],
        elevation: 10.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        title: new Text('Add ' + products[index]['name'] + ' to Cart?'),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                addToCart(index);
              },
              child: Text("Yes")),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No")),
        ],
      ),
    );
  }

  void addToCart(int index) {
    int quantity = int.parse(products[index]["quantity"]);
    print(quantity);
    print(products[index]["id"]);
    print(widget.user.email);
    if (quantity > 0) {
      Dialogs.showLoadingDialog(context, _keyLoader);
      String urlAddCart =
          "http://www.hackanana.com/beautylens/php/add_to_cart.php";
      http.post(urlAddCart, body: {
        "email": widget.user.email,
        "products_id": products[index]["id"],
      }).then((res) {
        print(res.body);
        if (res.body == "failed") {
          MainMenu.scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent[100],
              content: Text(
                'Failed Add to Cart',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          );
        } else {
          List respond = res.body.split(",");

          setState(() {
            cartQuantity = respond[1];
            widget.user.quantity = cartQuantity;
            _loadProducts();
          });

          MainMenu.scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent[100],
              content: Text(
                'Succes Add to Cart',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      }).catchError((err) {
        print(err);

        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
      //  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    } else {
      MainMenu.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent[100],
          content: Text(
            'Out of Stock',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  void _refreshCartQuantity() async {
    String urlLoadJobs =
        "https://hackanana.com/beautylens/php/refresh_cart_quantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        setState(() {
          cartQuantity = res.body;
          widget.user.quantity = cartQuantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
