import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trident/top_bar.dart';

class TournamentHistoryPage extends StatefulWidget{
  @override
  _TournamentHistoryPageState createState() => _TournamentHistoryPageState();
}

class _TournamentHistoryPageState extends State<TournamentHistoryPage>{

  int tabsIndex  = 0;
  String title = "Played tournaments";

  final tabs = [
    _playedEventPage(),
    _organizedEventPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Stack(children: <Widget>[ TopBar(),Align(alignment:Alignment.centerLeft,child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
          style: TextStyle(color:Colors.white,fontSize:30,),),
        ))])),
      body: Stack(
        children:<Widget>[tabs[tabsIndex],
        Align(alignment: Alignment.bottomCenter,child: 
         Container(
           width: MediaQuery.of(context).size.height/2,
           child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                      OutlineButton(
                        child: Text("Played"),
                        borderSide: BorderSide(
                          color:Colors.black
                        ),
                        onPressed: () {
                          setState(() {
                            tabsIndex = 0;
                            title = "Played tournaments";
                          });
                          
                        },
                      ),
                      OutlineButton(
                        child: Text("Organized"),
                        borderSide: BorderSide(
                          color:Colors.black
                        ),
                        onPressed: () {
                          setState(() {
                            tabsIndex = 1;
                            title = title = "Organized tournaments";
                          });
                        },
                      ),
                    ]),
         ),)
        ]),
    );
  }

}

_playedEventPage()
{
  return Scaffold(
    body: Container(child:Align(alignment:Alignment.center,child: Text("Played",style: TextStyle(color:Colors.black)))),
  );
}

_organizedEventPage()
{
  return Scaffold(
    body: Container(child:Align(alignment:Alignment.center,child: Text("Organized",style: TextStyle(color:Colors.black),)),),
  );
}