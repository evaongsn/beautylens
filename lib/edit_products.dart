import 'package:flutter/material.dart';
import 'admin_products_screen.dart';
import 'product.dart';
import 'dart:convert';
import 'dart:io';
import 'user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProducts extends StatefulWidget {
  final User user;
  final Product product;
  EditProducts({Key key, this.user, this.product}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  String server = "https://hackanana.com/beautylens";
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController powerEditingController = new TextEditingController();
  TextEditingController sizeEditingController = new TextEditingController();
  TextEditingController expirationTimeEditingController =
      new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;
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
    prnameEditingController.text = widget.product.name;
    priceEditingController.text = widget.product.price.toString();
    qtyEditingController.text = widget.product.quantity.toString();
    typeEditingController.text = widget.product.type;
    powerEditingController.text = widget.product.power.toString();
    sizeEditingController.text = widget.product.size.toString();
    expirationTimeEditingController.text = widget.product.expirationtime;

    selectedType = widget.product.type;
    print(selectedType);
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
                width: 65,
              ),
              Text(
                'Edit Product',
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
              onTap: _choose,
              child: Column(
                children: [
                  Visibility(
                    visible: _takepicture,
                    child: Container(
                      height: screenHeight / 6,
                      width: screenWidth / 2.5,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            server + "/product_images/${widget.product.id}.jpg",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _takepicturelocal,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop),
                            image: _image == null
                                ? AssetImage('assets/images/phonecam.png')
                                : FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                ],
              )),
          SizedBox(height: 10),
          Container(
              width: screenWidth / 0.8,
              height: screenHeight / 1.45,
              child: Card(
                  elevation: 6,
                  color: Colors.indigo[100],
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Edit Product Details',
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
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text("Product ID",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ))),
                                  ),
                                  TableCell(
                                      child: Container(
                                    height: 30,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          " " + widget.product.id,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                  )),
                                ]),
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
                                          textInputAction: TextInputAction.next,
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
                                          textInputAction: TextInputAction.next,
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
                                          textInputAction: TextInputAction.next,
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
                                                      color:
                                                          Colors.indigo[700])),
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
                                        child: Text("Size (mm)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black))),
                                  ),
                                  TableCell(
                                      child: Container(
                                    height: 30,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          " " + widget.product.size,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                  )),
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
                                    height: 30,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          " " + widget.product.expirationtime,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                  )),
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
                                    height: 30,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          " " + widget.product.power,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                  )),
                                ]),
                              ]),
                          SizedBox(height: 3),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            minWidth: screenWidth / 1.5,
                            height: 40,
                            child: Text('Edit Product'),
                            color: Colors.indigo[700],
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () => updateProductDialog(),
                          ),
                        ],
                      )))),
        ],
      )),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {});
  }

  updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Product Id " + widget.product.id,
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
                Navigator.of(context).pop();
                updateProduct();
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

  updateProduct() {
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
    double price = double.parse(priceEditingController.text);
    double size = double.parse(sizeEditingController.text);
    int power = int.parse(powerEditingController.text);
    int quantity = int.parse(qtyEditingController.text);
    String productName = prnameEditingController.text;

    String base64Image;

    if (_image != null) {
      print('iamgenotnull');
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server + "/php/edit_product.php", body: {
        "id": widget.product.id,
        "name": productName,
        "quantity": quantity.toString(),
        "price": price.toStringAsFixed(2),
        "type": selectedType,
        "size": size.toStringAsFixed(2),
        "expiration_time": expirationTimeEditingController.text,
        "power": power.toString(),
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);

        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      print('noimage');
      http.post(server + "/php/edit_product.php", body: {
        "id": widget.product.id,
        "name": productName,
        "quantity": quantity.toString(),
        "price": price.toStringAsFixed(2),
        "type": selectedType,
        "size": size.toStringAsFixed(2),
        "expiration_time": expirationTimeEditingController.text,
        "power": power.toString(),
      }).then((res) {
        print(res.body);

        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }
}
