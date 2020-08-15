import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trident/openingPage.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/user_feed.dart';
import 'package:trident/views/profile_page.dart';
import 'package:trident/views/splashScreen.dart';
import 'package:trident/widgets/provider_widget.dart';

void main() {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => HomeController(),
          "/userFeed": (context) => UserFeed(),
          "openingPage": (context) => OpeningPage(),
          "/profilePage": (context) => ProfilePage()
        },
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  static final OpeningPage openingPage = OpeningPage();
  static final SplashScreen screen = SplashScreen();

  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? screen : openingPage;
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
