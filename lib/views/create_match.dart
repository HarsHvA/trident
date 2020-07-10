import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class CreateMatch extends StatefulWidget {
  @override
  _CreateMatchState createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final formKey = new GlobalKey<FormState>();
  String _status, _prizePool, _map, _game, _imgUrl, _name, _matchNo = '';
  int _perKill, _ticket, _maxParticipants;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime _dateTime;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dog Mode',
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
      body: SingleChildScrollView(
        child: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Choose Game',
                      hintText: 'Please choose one',
                      value: _game,
                      onSaved: (value) {},
                      onChanged: (value) {
                        setState(() {
                          _game = value;
                        });
                      },
                      dataSource: [
                        {'display': 'PUBG Mobile', 'value': 'PUBG Mobile'},
                        {'display': 'PUBG Pc', 'value': 'PUBG Pc'},
                        {'display': 'PUBG Lite', 'value': 'PUBG Lite'},
                        {'display': 'Freefire', 'value': 'Freefire'}
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Choose Image',
                      hintText: 'Please choose one',
                      value: _imgUrl,
                      onSaved: (value) {},
                      onChanged: (value) {
                        setState(() {
                          _imgUrl = value;
                        });
                      },
                      dataSource: [
                        {
                          'display': 'PUBG',
                          'value':
                              'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/02/pubg-1580537222.jpg'
                        },
                        {
                          'display': 'Freefire',
                          'value':
                              'https://venturebeat.com/wp-content/uploads/2020/05/Garena-Free-Fire.jpg?w=1200&strip=all'
                        }
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Map',
                              style: TextStyle(
                                  fontSize: unitHeightValue * 2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              onSaved: (value) {
                                _map = value;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: unitHeightValue * 2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              onSaved: (value) {
                                _name = value;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Match no',
                              style: TextStyle(
                                  fontSize: unitHeightValue * 2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              onSaved: (value) {
                                _matchNo = value.toString();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(1, 16, 1, 16),
                          child: DropDownFormField(
                            titleText: 'Choose Status',
                            hintText: 'Please choose one',
                            value: _status,
                            onSaved: (value) {},
                            onChanged: (value) {
                              setState(() {
                                _status = value;
                              });
                            },
                            dataSource: [
                              {'display': 'Upcoming', 'value': 'Upcoming'},
                              {'display': 'Live', 'value': 'Live'},
                              {'display': 'Completed', 'value': 'Completed'},
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Prize Pool',
                              style: TextStyle(
                                  fontSize: unitHeightValue * 2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              onSaved: (value) {
                                _prizePool = value.toString();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'PerKill',
                              style: TextStyle(
                                  fontSize: unitHeightValue * 2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              onSaved: (input) {
                                _perKill = int.parse(input);
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'MaxParticipants',
                                  style: TextStyle(
                                      fontSize: unitHeightValue * 2,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  onSaved: (value) {
                                    _maxParticipants = int.parse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Ticket',
                                  style: TextStyle(
                                      fontSize: unitHeightValue * 2,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  onSaved: (value) {
                                    _ticket = int.parse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          'Choose Date and Time (${format.pattern})'),
                                      DateTimeField(
                                        format: format,
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            return DateTimeField.combine(
                                                date, time);
                                          } else {
                                            return currentValue;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400])),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400])),
                                        ),
                                        onSaved: (value) {
                                          _dateTime = value;
                                        },
                                      ),
                                    ]),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    color: Colors.red,
                                    colorBrightness: Brightness.light,
                                    onPressed: () {
                                      formKey.currentState.save();
                                      _createMatch();
                                    },
                                    child: Text('Create match'),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _createMatch() async {
    pr.show();
    CollectionReference matchsCollection =
        Firestore.instance.collection('customMatchRooms');

    try {
      await matchsCollection.add({
        'game': _game,
        'name': _name,
        'imageUrl': _imgUrl,
        'map': _map,
        'matchNo': _matchNo,
        'maxParticipants': _maxParticipants,
        'perKill': _perKill,
        'prizePool': _prizePool,
        'status': _status,
        'ticket': _ticket,
        'time': _dateTime
      });
      pr.hide();
      Toast.show('Match created', context);
      Navigator.pop(context);
    } catch (e) {
      pr.hide();
      Toast.show(e.toString(), context);
    }
  }
}
