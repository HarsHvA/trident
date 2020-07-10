import "package:flutter/material.dart";
import 'package:trident/models/user_model.dart';
import 'package:trident/services/database_services.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Wallet',
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
        body: FutureBuilder<User>(
            initialData: User(),
            future: DatabaseService().getUserInformation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_balance_wallet,
                              size: unitHeightValue * 10,
                              color: Colors.red.shade900,
                            ),
                            Text(
                              '\u20B9 ' + snapshot.data.walletMoney.toString(),
                              style: TextStyle(fontSize: unitHeightValue * 4),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.green,
                            colorBrightness: Brightness.light,
                            onPressed: () {},
                            child: Text('Withdraw'),
                            textColor: Colors.white,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.red,
                            colorBrightness: Brightness.light,
                            onPressed: () {},
                            child: Text('Help'),
                            textColor: Colors.white,
                          ),
                        ),
                        // TODO: add transcation history table here
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text("Loading..."));
              }
            }),
      ),
    );
  }
}
