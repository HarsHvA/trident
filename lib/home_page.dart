import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameHomePage extends StatefulWidget{
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<GameHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBody: true,
  backgroundColor: Colors.amber,
  body:   Container(
      child: Center(child: Text("User",style:TextStyle(color:Colors.black )))),
    );
  }
}