import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trident/home_page.dart';
import 'package:trident/private_games.dart';
import 'package:trident/user_page.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  int currentIndex = 0;
  int _selectedIndex = 0;
  double buttonIconPadding = 120;

  bool homeState = true;
  bool privateState = false;
  bool userState = false;
  bool barVisibility = true;

  var buttonIcon = Icons.arrow_drop_down;

  final tabs = [
    _homeTab(),
    _privateTab(),
    _meTab(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Stack(children: <Widget>[
          tabs[_selectedIndex],
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: new EdgeInsets.fromLTRB(1, 1, 25, buttonIconPadding),
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 25,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/gamepadicon.png")),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              title: Text('Ongoing'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('MyAccount'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red.shade900,
          onTap: _onItemTapped,
        ));
  }
}

// Tabs
_homeTab() {
  return GameHomePage();
}

_privateTab() {
  return PrivateGamesPage();
}

_meTab() {
  return UserPage();
}
