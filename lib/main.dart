import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trident/openingPage.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/user_feed.dart';
import 'package:trident/widgets/provider_widget.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return FutureBuilder<bool>(
        future: _checkInternetConnection(),
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return StreamBuilder<String>(
                stream: auth.onAuthStateChanged,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final bool signedIn = snapshot.hasData;
                    return signedIn ? UserFeed() : OpeningPage();
                  }
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OOPS!',
                        style:
                            TextStyle(color: Colors.red.shade900, fontSize: 25),
                      ),
                      Text('Please connect to internet to continue.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Colors.red.shade900,
                            colorBrightness: Brightness.light,
                            onPressed: () async {
                              await _checkInternetConnection();
                              setState(() {});
                            },
                            child: Text('OK'),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OOPS!',
                      style:
                          TextStyle(color: Colors.red.shade900, fontSize: 25),
                    ),
                    Text('Please connect to internet to continue.'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RaisedButton(
                          color: Colors.red.shade900,
                          colorBrightness: Brightness.light,
                          onPressed: () async {
                            await _checkInternetConnection();
                            setState(() {});
                          },
                          child: Text('OK'),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
