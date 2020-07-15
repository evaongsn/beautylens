import 'package:flutter/material.dart';
import 'admin_products_screen.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class AddNewProducts extends StatefulWidget {
  AddNewProducts({Key key}) : super(key: key);

  @override
  _AddNewProductsState createState() => _AddNewProductsState();
}

class _AddNewProductsState extends State<AddNewProducts> {
  String server = "https://hackanana.com/beautylens";
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;

  String pathAsset = 'assets/images/phonecam.jpg';
  // String product_id(int length) {
  //   var rand = new Random();
  //   var codeUnits = new List.generate(length, (index) {
  //     return rand.nextInt(33) + 89;
  //   });

  //   return new String.fromCharCodes(codeUnits);
  // }
  String product_id;
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController powerEditingController = new TextEditingController();
  TextEditingController sizeEditingController = new TextEditingController();
  TextEditingController expirationTimeEditingController =
      new TextEditingController();

  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  String selectedType;
  List<String> listType = [
    "Brilliant Colored",
    "Mochi",
    "Ocean Sky",
    "Seencon World II",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //  key: _scaffoldKey,
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
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  'New Product',
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
            GestureDetector(
                onTap: () => {_choose()},
                child: Container(
                  height: screenHeight / 3.5,
                  width: screenWidth / 1.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      width: 3.0,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                  ),
                )),
            SizedBox(height: 5),
            Text("Click the above image to take picture of your product",
                style: TextStyle(fontSize: 10.0, color: Colors.black)),
            SizedBox(height: 5),
            Container(
                width: screenWidth / 0.8,
                height: screenHeight / 1.82,
                child: Card(
                    color: Colors.indigo[100],
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                columnWidths: {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(6),
                                },
                                children: [
                                  // TableRow(children: [
                                  //   TableCell(
                                  //     child: Container(
                                  //         alignment: Alignment.centerLeft,
                                  //         height: 30,
                                  //         child: Text("Product ID",
                                  //             style: TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               color: Colors.black,
                                  //             ))),
                                  //   ),
                                  //   TableCell(
                                  //       child: Container(
                                  //     height: 30,
                                  //     child: Container(
                                  //         alignment: Alignment.centerLeft,
                                  //         height: 30,
                                  //         child: GestureDetector(
                                  //           //   onTap: _showPopupMenu,
                                  //           onTapDown: _storePosition,
                                  //           child: Text(product_id,
                                  //               style: TextStyle(
                                  //                 color: Colors.black,
                                  //               )),
                                  //         )),
                                  //   )),
                                  // ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Product Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: prnameEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Price (RM)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: priceEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: qtyEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 40,
                                        child: Container(
                                          height: 40,
                                          child: DropdownButton(
                                            //sorting dropdownoption
                                            hint: Text(
                                              'Type',
                                              style: TextStyle(
                                                color: Colors.indigo[700],
                                              ),
                                            ), // Not necessary for Option 1
                                            value: selectedType,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedType = newValue;
                                                print(selectedType);
                                              });
                                            },
                                            items: listType.map((selectedType) {
                                              return DropdownMenuItem(
                                                child: new Text(selectedType,
                                                    style: TextStyle(
                                                      color: Colors.indigo[700],
                                                    )),
                                                value: selectedType,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Size",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: sizeEditingController,
                                            //  keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus2,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus3);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Expiration Time",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller:
                                                expirationTimeEditingController,
                                            //  keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus3,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus4);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Power",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: powerEditingController,
                                            //  keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus4,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus4);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 3),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Add Product'),
                              color: Colors.indigo[700],
                              textColor: Colors.white,
                              elevation: 5,
                              onPressed: _insertNewProduct,
                            ),
                          ],
                        )))),
          ],
        ),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {});
  }

  void _insertNewProduct() {
    if (_image == null) {
      Toast.show("Please take product photo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (powerEditingController.text.length < 1) {
      Toast.show("Please enter product power", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (sizeEditingController.text.length < 1) {
      Toast.show("Please enter product size", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (expirationTimeEditingController.text.length < 1) {
      Toast.show("Please enter product expiration time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    product_id = (prnameEditingController.text.substring(0, 4) +
        "_" +
        randomNumber.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Add New Product Id " +
                product_id +
                "\nName:" +
                prnameEditingController.text,
            style: TextStyle(color: Colors.black),
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
                Navigator.of(context).pop();
                insertProduct();
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

  insertProduct() {
    double price = double.parse(priceEditingController.text);
    double size = double.parse(sizeEditingController.text);
    int power = int.parse(powerEditingController.text);
    int quantity = int.parse(qtyEditingController.text);
    String productName = prnameEditingController.text;
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(product_id +
        productName +
        quantity.toString() +
        price.toString() +
        selectedType +
        size.toString() +
        expirationTimeEditingController.text +
        power.toString() +
        base64Image);

    http.post("http://hackanana.com/beautylens/php/add_new_product.php", body: {
      "pid": product_id,
      "pname": productName,
      "quantity": quantity.toString(),
      "price": price.toString(),
      "type": selectedType,
      "size": size.toString(),
      "expiration_time": expirationTimeEditingController.text,
      "power": power.toString(),
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "found") {
        Toast.show("Product id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
