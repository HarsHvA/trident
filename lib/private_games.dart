import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivateGamesPage extends StatefulWidget{
  @override
  _PrivateGamesPageState createState() => _PrivateGamesPageState();
}

class _PrivateGamesPageState extends State<PrivateGamesPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.blue,
  extendBody: true,
  body:   Container(
      child: Center(child: Text("Private",style:TextStyle(color:Colors.black )))),
  );
}

}