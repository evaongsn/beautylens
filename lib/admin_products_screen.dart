import 'package:beautylens/add_new_products.dart';
import 'package:beautylens/main_menu.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:beautylens/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_new_products.dart';
import 'product.dart';
import 'edit_products.dart';
import 'package:toast/toast.dart';

class AdminProductsScreen extends StatefulWidget {
  final User user;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  AdminProductsScreen({Key key, this.user}) : super(key: key);

  @override
  _AdminProductsScreenState createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List products;
  int curNum = 1;
  double screenHeight, screenWidth;
  bool visible = false;
  bool visibleSearch = false;
  bool isAdmin = false;
  String curType = "Recent";
  String cartQuantity;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final navigatorKey = GlobalKey<NavigatorState>();
  // NavigationDrawerBloc bloc = NavigationDrawerBloc();
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
                    width: 55,
                  ),
                  Text(
                    'Manage Products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
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
          key: AdminProductsScreen.scaffoldKey,

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      }),
                  // SizedBox(width: 20),
                  Text(
                    'Manage Products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  // SizedBox(width: 5),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      curType,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    // Text(
                    //   'Add',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    ClipOval(
                      child: Material(
                        color: Colors.indigo[400], // button color
                        child: InkWell(
                          splashColor: Colors.indigo[200], // inkwell color
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                          onTap: () {
                            addNewProducts();
                          },
                        ),
                      ),
                    ),

                    // InkWell(
                    //   splashColor: Colors.indigo[400],
                    //   onTap: () {
                    //     addNewProducts();
                    //   },
                    //   child: ClipOval(
                    //     child: Icon(
                    //       Icons.add,
                    //       semanticLabel: "Add",
                    //       color: Colors.indigo[800],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  itemCount: products != null ? products.length : 0,
                  itemBuilder: (context, index) {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // SizedBox(
                            //   width: 20,
                            // ),
                            GestureDetector(
                              //  onTap: () => imageDisplay(index),
                              child: Container(
                                  height: screenWidth / 5,
                                  width: screenWidth / 3,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.indigo),
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              "http://hackanana.com/beautylens/product_images/${products[index]['id']}.jpg")))),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child:
                                Text(products[index]['name'],
                                    maxLines: 2,
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        // fontSize: 14)),
                                        )),
                                //  ),
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child:
                                Text(
                                  "RM " + products[index]['price'],
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Power: " + products[index]['power']),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Size: " +
                                      products[index]['size'] +
                                      " mm"),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text("Type: " + products[index]['type']),
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
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => editProductDetails(index),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.indigo[700],
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () => deleteProductDialog(index),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent[100],
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
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

    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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

    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  editProductDetails(int index) async {
    print(products[index]['name']);
    Product product = new Product(
        id: products[index]['id'],
        name: products[index]['name'],
        price: products[index]['price'],
        quantity: products[index]['quantity'],
        power: products[index]['power'],
        size: products[index]['size'],
        expirationtime: products[index]['expiration_time'],
        type: products[index]['type'],
        date: products[index]['date']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProducts(
                  user: widget.user,
                  product: product,
                )));
    _loadProducts();
  }

  Future<void> addNewProducts() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AddNewProducts()));
    _loadProducts();
  }

  void deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Product Id " + products[index]['id'],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.indigo[700],
                ),
              ),
              onPressed: () {
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.indigo[700],
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

  void _deleteProduct(int index) {
    String id = products[index]['id'];
    print("id:" + id);
    http.post("http://hackanana.com/beautylens/php/delete_product.php", body: {
      "id": id,
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadProducts();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
