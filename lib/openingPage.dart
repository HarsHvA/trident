import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trident/animation/FadeAnimation.dart';
import 'package:trident/signup.dart';
import 'package:trident/login.dart';

class OpeningPage extends StatefulWidget {
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Welcome to Trident!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: unitHeightValue * 4.1),
                        ),
                      )),
                  SizedBox(
                    height: unitHeightValue * 2,
                  ),
                  FadeAnimation(
                      1.2,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "The Ultimate! ESports tournament platform made by gamers.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: unitHeightValue * 1.6),
                        ),
                      )),
                ],
              ),
              FadeAnimation(
                  1.4,
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/skull.jpg'))),
                  )),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      MaterialButton(
                        minWidth: double.infinity,
                        height: unitHeightValue * 7,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 8)),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: unitHeightValue * 2),
                        ),
                      )),
                  SizedBox(
                    height: unitHeightValue * 2,
                  ),
                  FadeAnimation(
                      1.6,
                      Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 8),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: unitHeightValue * 7,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()));
                          },
                          color: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(unitWidthValue * 8)),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: unitHeightValue * 2),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
