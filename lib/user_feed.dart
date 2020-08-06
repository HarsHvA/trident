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

  static final GameHomePage _home = GameHomePage();
  static final OngoingGamesTab _ongoingView = OngoingGamesTab();
  static final UserPage _userView = UserPage();

  final tabs = [_home, _ongoingView, _userView];
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
          type: BottomNavigationBarType.fixed,
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
