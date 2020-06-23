import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trident/home_page.dart';
import 'package:trident/private_games.dart';
import 'package:trident/user_page.dart';

class UserFeed extends StatefulWidget{
  @override
  _UserFeedState  createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed>{

  int currentIndex = 0;

  bool homeState = true;
  bool privateState = false;
  bool userState = false;

  final tabs = [
    _homeTab(),
    _privateTab(),
    _meTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: tabs[currentIndex],
      bottomNavigationBar: _getNavBar(context),
  );
  }

_getNavBar(context) {
  return Container(
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.red,
                    Colors.red.shade900,
                  ])),
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(child: Container(child:_buildNavItem(Icons.home, homeState),),
              onTap: (){
                setState(() {
                  currentIndex = 0;
                  homeState = true;
                  privateState = false;
                  userState = false;
                });
              },),
              SizedBox(width: 1),
              GestureDetector(child: Container(child:_buildNavItem(Icons.supervised_user_circle, privateState),),
              onTap: (){
                setState(() {
                  currentIndex = 1;
                  homeState = false;
                  privateState = true;
                  userState = false;
                });
              },),
              SizedBox(width: 1),
              GestureDetector(child: Container(child:_buildNavItem(Icons.person, userState),),
              onTap: (){
                setState(() {
                  currentIndex = 2;
                  homeState = false;
                  privateState = false;
                  userState = true;
                });
              },),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 18, 2),
                child: Text('Home',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                width: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 22, 2),
                child: Text('Private',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                width: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 15, 2),
                child: Text('Me',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
}

// Tabs
_homeTab(){
return GameHomePage();
}

_privateTab(){
return PrivateGamesPage();
}

_meTab(){
return UserPage();
}

// Bottom App bar



_buildNavItem(IconData icon, bool active) {
  return CircleAvatar(
    radius: 30,
    backgroundColor: Colors.red.shade900,
    child: CircleAvatar(
      radius: 25,
      backgroundColor:
          active ? Colors.white.withOpacity(0.9) : Colors.transparent,
      child: Icon(
        icon,
        color: active ? Colors.black : Colors.white.withOpacity(0.9),
      ),
    ),
  );
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}