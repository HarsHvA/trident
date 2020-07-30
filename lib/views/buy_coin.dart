import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/services/database_services.dart';

class BuyCoinPage extends StatefulWidget {
  @override
  _BuyCoinPageState createState() => _BuyCoinPageState();
}

class _BuyCoinPageState extends State<BuyCoinPage> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
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
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buy Coins',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 10,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: unitHeightValue * 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.info_outline),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'You can use these coins to participate in matches'),
                    ),
                  ],
                )),
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 30 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '30',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(30, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 30",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 50 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '50',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(50, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 50",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 100 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '100',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(100, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 100",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 150 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '150',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(150, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 150",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 300 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '300',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(300, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 300",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Buy 500 gems',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: unitWidthValue * 12,
                                            height: unitHeightValue * 12,
                                            child:
                                                Image.asset('assets/gems.png')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '500',
                                            style: TextStyle(
                                                fontSize:
                                                    unitHeightValue * 2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 8),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: unitHeightValue * 5,
                                  onPressed: () {
                                    _buyGems(500, context);
                                  },
                                  color: Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Buy \u20B9 500",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitHeightValue * 1.8,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buyGems(gems, context) async {
    pr.show();
    try {
      await DatabaseService().addCoinsToWallet(gems, context);
      pr.hide();
      Toast.show('Gems Added!', context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      pr.hide();
      Toast.show('Failed', context);
    }
  }
}
