import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trident/views/ongoing_games_tab.dart';
import 'package:trident/views/user_home_tab.dart';
import 'package:trident/user_page.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  int currentIndex = 0;
  int _selectedIndex = 0;

  var buttonIcon = Icons.arrow_drop_down;

  final tabs = [
    _homeTab(),
    _privateTab(),
    _meTab(),
  ];

  _onItemTapped(int index) {
    if (this.mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: tabs[_selectedIndex],
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
  return OngoingGamesTab();
}

_meTab() {
  return UserPage();
}
