import 'package:flutter/material.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.amber,
      body: Container(
          child: Center(
              child: Text("User", style: TextStyle(color: Colors.black)))),
    );
  }
}
