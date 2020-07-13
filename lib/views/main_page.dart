import 'package:flutter/material.dart';
import 'package:trident/views/all_matches.dart';
import 'package:trident/views/create_match.dart';

class DogPage extends StatefulWidget {
  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dog Mode',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.red.shade900,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: unitHeightValue * 2,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              child: Card(
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      size: unitHeightValue * 10,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "CreateMatch",
                        style: TextStyle(
                            fontSize: unitHeightValue * 2, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                color: Colors.red.shade800,
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => CreateMatch()));
              },
            ),
            Card(
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_balance_wallet,
                    size: unitHeightValue * 10,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Withdrawl request",
                      style: TextStyle(
                          fontSize: unitHeightValue * 2, color: Colors.white),
                    ),
                  ),
                ],
              ),
              color: Colors.red.shade800,
            ),
            GestureDetector(
              child: Card(
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.assessment,
                      size: unitHeightValue * 10,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Manage matches",
                        style: TextStyle(
                            fontSize: unitHeightValue * 2, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                color: Colors.red.shade800,
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => AllMatches()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
