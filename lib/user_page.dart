import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trident/account_details_page.dart';
import 'package:trident/openingPage.dart';
import 'package:trident/top_bar.dart';
import 'package:trident/tournament_history_page.dart';
import 'package:trident/widgets/provider_widget.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: Stack(children: <Widget>[
          TopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 35),
            // TODO: Change username and image asset source to firestore
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 46,
                          child: ClipOval(
                              child:
                                  Image.asset("assets/default_avatar.jpg")))),
                  Text("Username",
                      style: TextStyle(fontSize: 25, color: Colors.white))
                ],
              ),
            ),
          )
        ]),
      ),
      body: Wrap(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 10),
                  children: <Widget>[
                    _buildListItems('Create Tournament', 0, context),
                    _buildListItems('My Wallet', 1, context),
                    _buildListItems('Account details', 2, context),
                    _buildListItems('Tournament History', 3, context),
                    _buildListItems('Help', 4, context),
                    _buildListItems('feedback', 5, context),
                    _buildListItems('Logout', 6, context),
                  ],
                )),
          ],
        ),
      ]),
    );
  }

  _buildListItems(label, index, context) {
    return Container(
        child: GestureDetector(
      child: Card(
          child: ListTile(
        title: Text(label),
      )),
      onTap: () {
        Toast.show(label, context);
        switch (index) {
          case 0:
            Toast.show(label, context);
            break;
          case 1:
            Toast.show(label, context);
            break;

          case 2:
            Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => AccountDetails()));
            break;

          case 3:
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) => TournamentHistoryPage()));
            break;

          case 4:
            Toast.show(label, context);
            break;
          case 5:
            Toast.show(label, context);
            break;
          case 6:
            _logout();
            break;
          default:
            Toast.show('Oops! Something went wrong', context);
            break;
        }
      },
    ));
  }

  void _logout() {
    final auth = Provider.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OpeningPage()));
  }
}
