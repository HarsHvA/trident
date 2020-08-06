import "package:flutter/material.dart";
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:trident/user_feed.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> _checkInternetConnection() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } on SocketException catch (_) {
          return false;
        }
      } else {
        return false;
      }
    }

    return FutureBuilder<bool>(
        future: _checkInternetConnection(),
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return UserFeed();
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
                              bool _hasInternet =
                                  await _checkInternetConnection();
                              if (_hasInternet) {
                                Navigator.pushNamed(context, "/userFeed");
                              }
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
                            bool _hasInternet =
                                await _checkInternetConnection();
                            if (_hasInternet) {
                              Navigator.pushNamed(context, "/userFeed");
                            }
                          },
                          child: Text('Retry'),
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
