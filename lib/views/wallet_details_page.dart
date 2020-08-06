import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:trident/models/user_model.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/views/buy_coin.dart';
import 'package:trident/views/transaction_page.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final formKey = GlobalKey<FormState>();
  int _mobileNumber = 0;
  String _mode, _error;
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
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
            future: DatabaseService().getUserInformation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      showAlert(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.red.shade900,
                                    ),
                                    Text(
                                        'Gems are used to play in tournaments'),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Image.asset('assets/gems.png'),
                                  Text(
                                    snapshot.data.gems.toString() ?? '0',
                                    style: TextStyle(
                                        fontSize: unitHeightValue * 4),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  colorBrightness: Brightness.light,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BuyCoinPage()));
                                  },
                                  child: Text('Buy Gems'),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.red,
                                  colorBrightness: Brightness.light,
                                  onPressed: () async {
                                    await _sendMail('Help with buying gems');
                                  },
                                  child: Text('Help'),
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.red.shade900,
                                    ),
                                    Text('Your Match winnings'),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_balance_wallet,
                                    size: unitHeightValue * 10,
                                    color: Colors.red.shade900,
                                  ),
                                  Text(
                                    '\u20B9 ' +
                                            snapshot.data.walletMoney
                                                .toString() ??
                                        '0',
                                    style: TextStyle(
                                        fontSize: unitHeightValue * 4),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.green,
                                  colorBrightness: Brightness.light,
                                  onPressed: () {
                                    _sendWithdrawRequest(
                                        snapshot.data.walletMoney);
                                  },
                                  child: Text('Withdraw'),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.red,
                                  colorBrightness: Brightness.light,
                                  onPressed: () async {
                                    await _sendMail('Help with withdrawal');
                                  },
                                  child: Text('Help'),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.black,
                                  colorBrightness: Brightness.light,
                                  onPressed: () async {
                                    String uid = await _getUserId();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionHistoryPage(
                                                  uid: uid,
                                                )));
                                  },
                                  child: Text('Transactions'),
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  _getUserId() async {
    return await AuthService().uID();
  }

  _sendWithdrawRequest(walletMoney) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Wrap(
            children: [
              Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Send Withdrawal request'),
                      ),
                      _buildFormInput('Mode'),
                      _buildFormInput('MobileNumber'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.black,
                            colorBrightness: Brightness.light,
                            onPressed: () {
                              formKey.currentState.save();
                              _sendUserWithdrawlRequest(walletMoney);
                            },
                            child: Text('Send request'),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.green,
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

  _sendUserWithdrawlRequest(walletMoney) async {
    pr.show();
    String userId = await AuthService().uID();
    CollectionReference userCollection = Firestore.instance.collection('users');
    try {
      if (walletMoney > 20) {
        await DatabaseService().addWithdrawlrequest(
            walletMoney, FieldValue.serverTimestamp(), _mode, _mobileNumber);
        await DatabaseService().sendWithdrawlrequest(
            walletMoney, FieldValue.serverTimestamp(), _mode, _mobileNumber);
        await Firestore.instance.runTransaction((transaction) async {
          await transaction
              .update(userCollection.document(userId), {'walletAmount': 0});
        });
        pr.hide();
        Navigator.pop(context);
        _error = 'Amount will be send to your wallet within 3 bussiness days';
        // Toast.show('Amount will be send to your wallet within 3 bussiness days',
        //     context);
      } else {
        pr.hide();
        Navigator.pop(context);
        // Toast.show('Minimum amount should be \u20B9 20', context);
        _error = 'Minimum amount should be \u20B9 20';
      }
    } catch (e) {
      pr.hide();
      Navigator.pop(context);
      // Toast.show(e.toString(), context);
      _error = e.toString();
    }
  }

  _buildFormInput(label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            onSaved: (newValue) {
              switch (label) {
                case "Mode":
                  _mode = newValue;
                  break;

                case "MobileNumber":
                  _mobileNumber = int.parse(newValue);
                  break;
              }
            },
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
                hintText: _getHints(label)),
            // autofillHints: _getHints(label),
          ),
        ],
      ),
    );
  }
}

_getHints(label) {
  if (label == 'Mode') {
    return 'Paytm/PhonePay';
  } else {
    return 'Mobile no';
  }
}

Future<void> _sendMail(subject) async {
  final Email email = Email(
    subject: 'Subject : ' + subject,
    // TODO: change recipenits
    recipients: ['rockssharsh0001@gmail.com'],
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print(error.toString());
  }
}
