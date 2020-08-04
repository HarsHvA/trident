import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/services/payment_service.dart';
import 'package:http/http.dart' as http;

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

  final webViewPlugin = FlutterWebviewPlugin();
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    webViewPlugin.close();
    if (mounted) {
      webViewPlugin.onUrlChanged.listen((String url) async {
        if (url.contains('https://www.iceagedev.com/blank')) {
          Uri uri = Uri.parse(url);
          String paymentRequestId = uri.queryParameters['payment_id'];
          // print('paymentId: ' + paymentRequestId);
          bool payment = await _checkPaymentStatus(paymentRequestId);
          if (payment) {
            await DatabaseService().addCoinsToWallet(int.parse(amount));
          }
          webViewPlugin.close();
          Navigator.of(context).pop();
        }
      });
    }
  }

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
                    hidden: true,
                    withZoom: true,
                    withLocalStorage: true,
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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  webViewPlugin.goBack();
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  webViewPlugin.goForward();
                },
              ),
              IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: () {
                  webViewPlugin.reload();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _checkPaymentStatus(id) async {
    var response = await http.get(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "2451e1523b32cf3e809fd0a49ecf009b",
          "X-Auth-Token": "7566dcde2ea581004623c54d1b54857f"
        });

    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print("payment is successful.");
        return true;
      } else {
        print('payment failed or pending.');
        return false;
      }
    } else {
      print("PAYMENT STATUS FAILED");
      return false;
    }
  }
}
