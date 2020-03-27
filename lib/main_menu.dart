import 'package:flutter/material.dart';
import 'package:beautylens/user.dart';

class MainMenu extends StatefulWidget {
  final User user;
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  const MainMenu({Key key, this.user}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List stocks = [];
  int curnum = 1;
  double screenHeight, screenWidth;
  bool visible = false;
  String curtype = 'Recent';
  String quantity = '0';

  @override
  void initState() {
    super.initState();
    //  _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController productController = new TextEditingController();
    if (stocks == null) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu, size: 30, color: Colors.indigo[300]),
                    onPressed: () => MainMenu.scaffoldKey.currentState.openDrawer(),
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
            // otherAccountsPictures: <Widget>[
            //   Text("RM" + widget.user.credit,
            //   style: TextStyle(fontSize: 16,
            //   color: Colors.white),),
            // ],
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.android ? Colors.white : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0,1).toUpperCase(),
                style: TextStyle(fontSize: 20.0),
              )
            ),
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
}
