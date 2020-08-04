import 'package:trident/signup.dart';
import 'package:flutter/material.dart';
import 'package:trident/animation/FadeAnimation.dart';
import 'package:trident/user_feed.dart';
import 'package:trident/views/reset_password_page.dart';
import 'package:trident/widgets/provider_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _error;
  bool _autoValidate = false;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: "Please wait...",
      borderRadius: 5.0,
      padding: EdgeInsets.all(25),
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red.shade900),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: unitHeightValue * 2,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: _height * 0.025),
              showAlert(),
              SizedBox(height: _height * 0.025),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: unitHeightValue * 3,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: unitHeightValue * 2,
                        ),
                        FadeAnimation(
                            1.2,
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                  fontSize: unitHeightValue * 1.8,
                                  color: Colors.grey[700]),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.2,
                                makeInput(
                                    label: "Email", validator: validateEmail)),
                            FadeAnimation(
                                1.3,
                                makeInput(
                                    label: "Password",
                                    obscureText: true,
                                    validator: validatePassword))
                          ],
                        ),
                      ),
                    ),
                    FadeAnimation(
                        1.4,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
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
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  submit();
                                } else {
                                  setState(() => _autoValidate = true);
                                }
                              },
                              color: Colors.greenAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitHeightValue * 1.8),
                              ),
                            ),
                          ),
                        )),
                    Column(children: <Widget>[
                      FadeAnimation(
                          1.5,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordPage()));
                            },
                            child: Text(
                              "Forgot Password!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: unitHeightValue * 1.7),
                            ),
                          )),
                      SizedBox(
                        height: unitHeightValue * 1,
                      ),
                      FadeAnimation(
                          1.6,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style:
                                    TextStyle(fontSize: unitHeightValue * 1.7),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage()));
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: unitHeightValue * 2),
                                ),
                              ),
                            ],
                          ))
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    try {
      pr.show();
      final auth = Provider.of(context).auth;
      String uid = await auth.signIn(_email, _password);
      pr.hide();
      print(uid);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserFeed()));
    } catch (e) {
      setState(() {
        _error = e.message;
      });
      pr.hide();
      print(e);
    }
  }

  String validatePassword(String value) {
    if (value.length < 8) {
      return 'Invalid Password';
    } else {
      return null;
    }
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  Widget makeInput({label, obscureText = false, validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validator,
          obscureText: obscureText,
          onSaved: (newValue) {
            switch (label) {
              case "Email":
                _email = newValue;
                break;

              case "Password":
                _password = newValue;
                break;
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.red.shade900,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
