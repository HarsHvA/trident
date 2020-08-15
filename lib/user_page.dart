import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:trident/openingPage.dart';
import 'package:trident/top_bar.dart';
import 'package:trident/views/profile_page.dart';
import 'package:trident/views/wallet_details_page.dart';
import 'package:trident/widgets/provider_widget.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _username = "";
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
    username();
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: Stack(children: <Widget>[
          TopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      radius: unitWidthValue * 12,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: unitWidthValue * 11,
                          child: ClipOval(
                              child:
                                  Image.asset("assets/default_avatar.jpg")))),
                  Text(_username,
                      style: TextStyle(
                          fontSize: unitHeightValue * 2.5, color: Colors.white))
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
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 10),
                  children: <Widget>[
                    _buildListItems('My Wallet', 0, context),
                    _buildListItems('Account details', 1, context),
                    _buildListItems('Help', 2, context),
                    _buildListItems('feedback', 3, context),
                    _buildListItems('Logout', 4, context),
                  ],
                )),
          ],
        ),
      ]),
    );
  }

  username() async {
    final _auth = Provider.of(context).auth;
    String name = await _auth.username();
    if (this.mounted) {
      setState(() {
        _username = name;
      });
    }
  }

  _buildListItems(label, index, context) {
    return Container(
        child: GestureDetector(
      child: Card(
          child: ListTile(
        title: Text(label),
      )),
      onTap: () {
        switch (index) {
          case 0:
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => WalletPage()));
            break;

          case 1:
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => ProfilePage()));
            break;

          case 2:
            _sendMail('General Help');
            break;
          case 3:
            _sendMail('Feedback');
            break;
          case 4:
            _logout();
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

  Future<void> _sendMail(subject) async {
    final Email email = Email(
      subject: 'Subject : ' + subject,
      recipients: ['help.iceagestud@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error.toString());
    }
  }
}
