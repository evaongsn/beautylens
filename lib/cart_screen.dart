
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
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
     if (cart == null) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
     return MaterialApp(
        debugShowCheckedModeBanner: false,
   
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
          ),
        ),
     );
      
    // } else {
    //   MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //     body: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         SizedBox(
    //           height: 45,
    //         ),
    //         Row(
    //           children: <Widget>[
    //             IconButton(
    //               icon: Icon(Icons.menu, size: 30, color: Colors.indigo[300]),
    //               onPressed: () {},
    //             ),
    //             SizedBox(
    //               width: 85,
    //             ),
    //             Text(
    //               'My Cart',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 fontSize: 28.0,
    //                 color: Colors.black,
    //                 fontFamily: 'Poppins',
    //               ),
    //             ),
    //           ],
    //         ),
    //         Divider(
    //           thickness: 2.0,
    //           indent: 10.0,
    //           endIndent: 10.0,
    //           color: Colors.black,
    //         ),
    //         ListView.builder(
    //           itemCount: cart == null ? 1 : cart.length + 2,
    //           itemBuilder: (context, index){
                
    //             if (index == cart.length){
    //               return Container(
    //               width: 0.0,
    //               height: 0.0,

    //         );}
    //             }
    //           )
    //       ],
    //     ),
    //   ),
    //   );
    }
  }

  void loadCart() {
    totalPrice = 0.0;
    totalProducts = 0;
    Dialogs.showLoadingDialog(context, _keyLoader);
    String urlLoadCart = "https://hackanana.com/beautylens/php/load_cart.php";
    http.post(urlLoadCart, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      setState(() {
        var extractdata = json.decode(res.body);
        cart = extractdata["cart"];
        for (int i = 0; i < cart.length; i++) {
          totalPrice = double.parse(cart[i]['cart_price']) + totalPrice;
          totalProducts = int.parse(cart[i]['cart_quantity']) + totalProducts;
        }
        print(totalPrice + totalProducts);
      });
    }).catchError((err) {
      print(err);
     
    });
    
  }
}
