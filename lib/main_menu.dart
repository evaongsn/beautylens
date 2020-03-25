import 'package:flutter/material.dart';
import 'package:beautylens/user.dart';

class MainMenu extends StatefulWidget {
   final User user;

  const MainMenu({Key key, this.user}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Container(),
    );
  }
}