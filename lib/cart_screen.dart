import 'package:flutter/material.dart';
import 'package:beautylens/user.dart';
import 'package:beautylens/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cart = [];
  double screenHeight, screenWidth;
  bool selfPickup = false;
  bool delivery = false;
  double totalPrice = 0.0;
  int totalProducts = 0;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void initState() {
    super.initState();
    print(cart);
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: cart == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu,
                            size: 30, color: Colors.indigo[300]),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      Text(
                        'My Cart',
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
                            "Loading Your Cart",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : 
            // Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       SizedBox(
            //         height: 45,
            //       ),
            //       Row(
            //         children: <Widget>[
            //           IconButton(
            //             icon: Icon(Icons.menu,
            //                 size: 30, color: Colors.indigo[300]),
            //             onPressed: () {},
            //           ),
            //           SizedBox(
            //             width: 85,
            //           ),
            //           Text(
            //             'My Cart',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               fontSize: 28.0,
            //               color: Colors.black,
            //               fontFamily: 'Poppins',
            //             ),
            //           ),
            //         ],
            //       ),
            //       Divider(
            //         thickness: 2.0,
            //         indent: 10.0,
            //         endIndent: 10.0,
            //         color: Colors.black,
            //       ),
                  ListView.builder(
                      itemCount: cart == null ? 1 : cart.length + 2,
                      itemBuilder: (context, index) {
                        if (index == cart.length) {
                          return Container(
                    height: screenHeight / 2.4,
                    width: screenWidth / 2.5,
                    child: InkWell(
                      onLongPress: () => {print("Delete")},
                      child: Card(
                        color: Colors.yellow,
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text("Delivery Option",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            // Text("Weight:" + _weight.toString() + " KG",
                            //     style: TextStyle(
                            //         fontSize: 16.0,
                            //         fontWeight: FontWeight.bold)),
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                  // color: Colors.red,
                                  width: screenWidth / 2,
                                  height: screenHeight / 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          // Checkbox(
                                          //   value: _selfPickup,
                                          //   onChanged: (bool value) {
                                          //     _onSelfPickUp(value);
                                          //   },
                                          // ),
                                          Text("Self Pickup"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                                    child: SizedBox(
                                        width: 2,
                                        child: Container(
                                          height: screenWidth / 2,
                                          color: Colors.grey,
                                        ))),
                                Expanded(
                                    child: Container(
                                  //color: Colors.blue,
                                  width: screenWidth / 2,
                                  height: screenHeight / 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          // Checkbox(
                                          //   value: _homeDelivery,
                                          //   onChanged: (bool value) {
                                          //     _onHomeDelivery(value);
                                          //   },
                                          // ),
                                          Text("Home Delivery"),
                                        ],
                                      ),
                                      // FlatButton(
                                      //   color: Colors.blue,
                                      //   onPressed: () => {_loadMapDialog()},
                                      //   child: Icon(
                                      //     MdiIcons.locationEnter,
                                      //     color: Colors.red,
                                      //   ),
                                      // ),
                                      Text("Current Address:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      // Row(
                                      //   children: <Widget>[
                                      //     Text("  "),
                                      //     Flexible(
                                      //       child: Text(
                                      //         curaddress ?? "Address not set",
                                      //         maxLines: 3,
                                      //         overflow: TextOverflow.ellipsis,
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                )),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ));
                        }
                        index -= 0;
                        return Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                        height: screenWidth / 4.8,
                                        width: screenWidth / 4.8,
                                        decoration: BoxDecoration(
                                            //shape: BoxShape.circle,
                                            //border: Border.all(color: Colors.black),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    "http://hackanana.com/beautylens/product_images/${cart[index]['id']}.jpg")))),
                                    Text(
                                      "RM " + cart[index]['price'],
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 1, 10, 1),
                                    child: SizedBox(
                                        width: 2,
                                        child: Container(
                                          height: screenWidth / 3.5,
                                          color: Colors.grey,
                                        ))),
                                Container(
                                  width: screenWidth / 1.45,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              cart[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              maxLines: 1,
                                            ),
                                            Text("Available " +
                                                cart[index]['quantity'] +
                                                " unit"),
                                            Text("Your Quantity " +
                                                cart[index]['cart_quantity']),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                //   FlatButton(
                                                //     onPressed: () =>
                                                //         {_updateCart(index, "add")},
                                                //     child: Icon(
                                                //    //   MdiIcons.plus,
                                                //       color: Colors.grey,
                                                //     ),
                                                //   ),
                                                //   Text(cart[index]['cquantity']),
                                                //   FlatButton(
                                                //     onPressed: () =>
                                                //  //       {_updateCart(index, "remove")},
                                                //     child: Icon(
                                                //  //     MdiIcons.minus,
                                                //       color: Colors.grey,
                                                //     ),
                                                //   ),
                                              ],
                                            ),
                                            Text(
                                                "RM " +
                                                    cart[index]['yourprice'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
               // ],
              //),
      ),
    );
  }

  void loadCart() {
    totalPrice = 0.0;
    totalProducts = 0;
    Dialogs.showLoadingDialog(context, _keyLoader);
    String urlLoadCart = "https://hackanana.com/beautylens/php/load_cart.php";
    http.post(urlLoadCart, body: {
      "email": widget.user.email,
    }).then((res) {
    print(cart.length);
      print(res.body);
      
      setState(() {
        var extractdata = json.decode(res.body);
        cart = extractdata["cart"];
      
        for (int i = 0; i < cart.length; i++) {
          totalPrice = double.parse(cart[i]['cart_price']) + totalPrice;
          totalProducts = int.parse(cart[i]['cart_quantity']) + totalProducts;
        }
        print(totalPrice);
        print(totalProducts);
             
     Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }).catchError((err) {
      print(err);
    });
  }
}
