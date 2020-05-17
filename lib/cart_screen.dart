import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:beautylens/loading_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'main_menu.dart';

class CartScreen extends StatefulWidget {
  final User user;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartList;
  double screenHeight, screenWidth;
  bool _selfPickup = true;
  bool _delivery = false;
  bool _credit = false;
  double totalPrice = 0.0;
  double deliveryCharge;
  double totalAmount;
  //maps
  Position _currentPosition;
  String curaddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: CartScreen.scaffoldKey,
        body: Container(
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
            cartList == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    'Loading Your Cart',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartList == null ? 1 : cartList.length + 2,
                        itemBuilder: (context, index) {
                          if (index == cartList.length) {
                            return Container(
                                height: screenHeight / 3,
                                width: screenWidth / 2.5,
                                child: InkWell(
                                  child: Card(
                                   elevation: 5,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Delivery Option",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        Expanded(
                                            child: Column(
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.red,
                                              width: screenWidth / 1,
                                              // height: screenHeight / 3,
                                              child: Row(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _selfPickup,
                                                        onChanged:
                                                            (bool value) {
                                                          _onSelfPickUp(value);
                                                        },
                                                      ),
                                                      Text(
                                                        "Self Pickup",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Padding(
                                            //     padding:
                                            //         EdgeInsets.fromLTRB(2, 1, 2, 1),
                                            //     child: SizedBox(
                                            //         width: 2,
                                            //         child: Container(
                                            //           // height: screenWidth / 2,
                                            //           color: Colors.grey,
                                            //         ))),
                                            Expanded(
                                                child: Container(
                                              //color: Colors.blue,
                                              width: screenWidth / 1,
                                              //height: screenHeight / 3,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _delivery,
                                                        onChanged:
                                                            (bool value) {
                                                          _onHomeDelivery(
                                                              value);
                                                        },
                                                      ),
                                                      Text(
                                                        "Home Delivery",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    //  SizedBox(width: 10),
                                                      OutlineButton(
                                                          color: Colors
                                                              .black,
                                                          onPressed: () => {
                                                                _loadMapDialog()
                                                              },
                                                          child: Icon(
                                                            Icons.my_location,
                                                            color: Colors.indigo[200],
                                                            size: 30,
                                                          ),
                                                          shape:
                                                              new CircleBorder()),
                                                    ],
                                                  ),
                                                  Align ( alignment: Alignment.centerLeft,
                                                    child: Text("  Current Address:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("  "),
                                                      Flexible(
                                                        child: Text(
                                                          curaddress ??
                                                              "Address not set",
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
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

                          if (index == cartList.length + 1) {
                            return Container(
                                //height: screenHeight / 3,
                                child: Card(
                           
                              elevation: 5,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Payment",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(height: 10),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(6, 0, 6, 0),
                         
                                      child: Table(
                                          defaultColumnWidth:
                                              FlexColumnWidth(1.0),
                                          columnWidths: {
                                            0: FlexColumnWidth(8),
                                            1: FlexColumnWidth(2),
                                          },
                                          //border: TableBorder.all(color: Colors.white),
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Total Item Price ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM" +
                                                              totalPrice
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          "0.0",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Delivery Charge ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM" +
                                                              deliveryCharge
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          "0.0",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Credit RM" +
                                                            widget.user.credit,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Checkbox(
                                                    value: _credit,
                                                    onChanged: (bool value) {
                                                      _onStoreCredit(value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text("Total Amount ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM" +
                                                              totalAmount
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          "0.0",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                          ])),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    minWidth: 200,
                                    height: 40,
                                    child: Text('Proceed to Payment'),
                                    color: Colors.indigo[200],
                                    textColor: Colors.black,
                                    elevation: 10,
                                    onPressed: makePayment,
                                  ),
                                ],
                              ),
                            ));
                          }
                          index -= 0;

                          return Card(
                            
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 8,
                                          width: screenWidth / 5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl:
                                                "http://hackanana.com/beautylens/product_images/${cartList[index]['id']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                        Text(
                                          "RM " + cartList[index]['price'],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 1.45,
                                        //color: Colors.blue,
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    cartList[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Your Quantity " +
                                                        cartList[index]
                                                            ['cart_quantity'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(
                                                                  index, "add")
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              color: Colors
                                                                  .indigo[200],
                                                            ),
                                                          ),
                                                          Text(
                                                            cartList[index][
                                                                'cart_quantity'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(index,
                                                                  "remove")
                                                            },
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: Colors.indigo[200],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          "Total RM " +
                                                              cartList[index][
                                                                  'cart_price'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                      FlatButton(
                                                        onPressed: () => {
                                                          _deleteCart(index)
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.indigo[200],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ])));
                        })),
          ],
        )));
  }

  void _loadCart() {
    totalPrice = 0.0;
    totalAmount = 0.0;
    deliveryCharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = "https://hackanana.com/beautylens/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      pr.hide().then((isHidden) {
        print(isHidden);
      });
      setState(() {
        var extractdata = json.decode(res.body);
        cartList = extractdata["cart"];
        for (int i = 0; i < cartList.length; i++) {
          totalPrice = double.parse(cartList[i]['cart_price']) + totalPrice;
        }
        totalAmount = totalPrice;

        print(totalPrice);
      });
    }).catchError((err) {
      print(err);
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    });
    pr.hide().then((isHidden) {
      print(isHidden);
    });
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartList[index]['quantity']);
    int quantity = int.parse(cartList[index]['cart_quantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = "https://hackanana.com/beautylens/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "products_id": cartList[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://hackanana.com/beautylens/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "products_id": cartList[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  void _onSelfPickUp(bool newValue) => setState(() {
        _selfPickup = newValue;
        if (_selfPickup) {
          _delivery = false;
          _updatePayment();
        } else {
          //_homeDelivery = true;
          _updatePayment();
        }
      });

  void _onStoreCredit(bool newValue) => setState(() {
        _credit = newValue;
        if (_credit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _onHomeDelivery(bool newValue) {
    _getLocation();
    setState(() {
      _delivery = newValue;
      if (_delivery) {
        _updatePayment();
        _selfPickup = false;
      } else {
        _updatePayment();
      }
    });
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    if (!mounted) return;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Select New Delivery Location",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  Text(
                    curaddress,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Close'),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)},
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  void _updatePayment() {
    double totalQuantity = double.parse(widget.user.quantity);
    totalPrice = 0.0;
    totalAmount = 0.0;
    setState(() {
      for (int i = 0; i < cartList.length; i++) {
        totalPrice = double.parse(cartList[i]['cart_price']) + totalPrice;
      }
      print(_selfPickup);
      if (_selfPickup) {
        deliveryCharge = 0.0;
      } else {
        if (totalPrice > 100) {
          deliveryCharge = 10.00;
        } else {
          deliveryCharge = totalQuantity * 3.0;
        }
      }

      if (_delivery) {
        if (totalPrice > 100) {
          deliveryCharge = 10.00;
        } else {
          deliveryCharge = totalQuantity * 3.0;
        }
      }
      if (_credit) {
        totalAmount =
            deliveryCharge + totalPrice - double.parse(widget.user.credit);
      } else {
        totalAmount = deliveryCharge + totalPrice;
      }

      print(totalQuantity);
      print(deliveryCharge);
      print(totalPrice);
    });
  }

  void makePayment() {
    if (_selfPickup) {
      print("PICKUP");
      CartScreen.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.greenAccent[100],
          content: Text(
            'Self Pickup',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
//        CartScreen.scaffoldKey.currentState.hideCurrentSnackBar();
    } else if (_delivery) {
      print("HOME DELIVERY");
      CartScreen.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.greenAccent[100],
          content: Text(
            'Home Delivery',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      //      Scaffold.of(context).hideCurrentSnackBar();
    } else {
      CartScreen.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.greenAccent[100],
          content: Text(
            'Please Select Delivery Option',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
      //      Scaffold.of(context).hideCurrentSnackBar();
    } //CartScreen.scaffoldKey.currentState.hideCurrentSnackBar();
  }
}
