import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:trident/top_bar.dart';
import 'package:trident/views/my_matches_tab.dart';
import 'package:trident/views/upcoming_match_tab.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.red.shade900);

    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              ThemeData(accentColor: Colors.white, primarySwatch: Colors.red),
          home: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(100),
                    child: Stack(children: <Widget>[
                      TopBar(),
                      TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              'Upcoming',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: unitHeightValue * 1.6),
                            ),
                          ),
                          Tab(
                              child: Text(
                            'MyTournaments',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: unitHeightValue * 1.6),
                          ))
                        ],
                      ),
                    ]),
                  ),
                  body: TabBarView(
                    children: [
                      UpcomingMatchesTab(),
                      MyMatchesTab(),
                    ],
                  ),
                ),
              ))),
    );
  }
}
