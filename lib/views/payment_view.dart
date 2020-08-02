import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trident/services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  final String amount, purpose, name, email;
  PaymentPage(
      {Key key,
      @required this.amount,
      @required this.purpose,
      @required this.name,
      @required this.email});
  @override
  _PaymentPageState createState() =>
      _PaymentPageState(amount, purpose, name, email);
}

class _PaymentPageState extends State<PaymentPage> {
  String amount, purpose, name, email;
  _PaymentPageState(this.amount, this.purpose, this.name, this.email);
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 10,
        brightness: Brightness.light,
        backgroundColor: Colors.red.shade900,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: unitHeightValue * 2,
          ),
        ),
      ),
      body: FutureBuilder(
          future: PaymentService(
                  amount: amount,
                  purpose: purpose,
                  name: name,
                  email: email,
                  context: context)
              .createRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Container(
                child: Text('Opps somthing went wrong!'),
              ));
            } else if (snapshot.hasData) {
              return WebviewScaffold(
                  url: snapshot.data,
                  initialChild: Center(
                    child: CircularProgressIndicator(),
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ));
  }
}
