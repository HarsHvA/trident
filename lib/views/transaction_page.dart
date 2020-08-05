import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trident/models/transaction_models.dart';
import 'package:trident/services/database_services.dart';

class TransactionHistoryPage extends StatefulWidget {
  final String uid;
  TransactionHistoryPage({Key key, @required this.uid}) : super(key: key);
  @override
  _TransactionHistoryPageState createState() =>
      _TransactionHistoryPageState(uid);
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  String uid;
  _TransactionHistoryPageState(this.uid);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: (TabBar(
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
            labelColor: Colors.red,
          )),
          body: TabBarView(children: [
            PendingTab(uid: uid),
            CompletedTab(
              uid: uid,
            )
          ]),
        ),
      ),
    );
  }
}

class PendingTab extends StatefulWidget {
  final String uid;
  PendingTab({Key key, @required this.uid}) : super(key: key);
  @override
  _PendingTabState createState() => _PendingTabState(uid);
}

class _PendingTabState extends State<PendingTab> {
  String uid;
  _PendingTabState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: StreamBuilder<List<UserTransactions>>(
                stream: DatabaseService().getUserPendingTransaction(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                'mode',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                              DataColumn(
                                  label: Text(
                                'amount',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                              DataColumn(
                                  label: Text(
                                'Mobile No',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                            ],
                            rows: snapshot.data
                                .map((e) => DataRow(cells: <DataCell>[
                                      DataCell(Text(
                                        e.mode ?? '',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      DataCell(Text(
                                        '\u20B9 ' + e.amount ?? '0',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      DataCell(Text(
                                        e.mobileNo ?? '',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ]))
                                .toList()));
                  } else {
                    return Container(
                      child: AutoSizeText('No pending transactions :-)'),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class CompletedTab extends StatefulWidget {
  final String uid;
  CompletedTab({Key key, @required this.uid}) : super(key: key);
  @override
  _CompletedTabState createState() => _CompletedTabState(uid);
}

class _CompletedTabState extends State<CompletedTab> {
  String uid;
  _CompletedTabState(this.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: StreamBuilder<List<UserTransactions>>(
                stream: DatabaseService().getUserCompletedTransaction(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                'Mode',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                              DataColumn(
                                  label: Text(
                                'Amount',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                              DataColumn(
                                  label: Text(
                                'Mobile No',
                                style: TextStyle(color: Colors.red.shade900),
                              )),
                            ],
                            rows: snapshot.data
                                .map((e) => DataRow(cells: <DataCell>[
                                      DataCell(Text(
                                        e.mode ?? '',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      DataCell(Text(
                                        '\u20B9 ' + e.amount ?? '0',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      DataCell(Text(
                                        e.mobileNo ?? '',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ]))
                                .toList()));
                  } else {
                    return Container(
                      child: AutoSizeText('No Completed transactions :-)'),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
