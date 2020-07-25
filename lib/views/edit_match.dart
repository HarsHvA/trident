import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/services/database_services.dart';

class EditMatch extends StatefulWidget {
  final String matchId;

  EditMatch({Key key, @required this.matchId}) : super(key: key);

  @override
  _EditMatchState createState() => _EditMatchState(matchId);
}

class _EditMatchState extends State<EditMatch> {
  String matchId;
  _EditMatchState(this.matchId);
  final formKey = new GlobalKey<FormState>();
  String _status, _prizePool, _name, _matchNo, _roomId, _roomPassword = '';
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
          'Edit Match',
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
          child: StreamBuilder<Matches>(
              stream: DatabaseService().getMatchDetails(matchId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
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
                                      initialValue: snapshot.data.name,
                                      onSaved: (value) {
                                        _name = value ?? snapshot.data.name;
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
                                      initialValue: snapshot.data.matchNo,
                                      onSaved: (value) {
                                        _matchNo = value.toString() ??
                                            snapshot.data.matchNo;
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
                                    onSaved: (value) {
                                      if (value == null) {
                                        _status = snapshot.data.status;
                                      } else {
                                        _status = value;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _status = value;
                                      });
                                    },
                                    dataSource: [
                                      {
                                        'display': 'Upcoming',
                                        'value': 'Upcoming'
                                      },
                                      {'display': 'Live', 'value': 'Live'},
                                      {
                                        'display': 'Completed',
                                        'value': 'Completed'
                                      },
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
                                      initialValue: snapshot.data.prizePool,
                                      onSaved: (value) {
                                        _prizePool = value.toString() ??
                                            snapshot.data.prizePool;
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
                                      initialValue:
                                          snapshot.data.perKill.toString(),
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      onSaved: (input) {
                                        _perKill = int.parse(input) ??
                                            snapshot.data.perKill;
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
                                          initialValue: snapshot
                                              .data.maxParticipants
                                              .toString(),
                                          onSaved: (value) {
                                            _maxParticipants =
                                                int.parse(value) ??
                                                    snapshot
                                                        .data.maxParticipants;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          initialValue:
                                              snapshot.data.ticket.toString(),
                                          onSaved: (value) {
                                            _ticket = int.parse(value) ??
                                                snapshot.data.ticket.toString();
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
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
                                                onShowPicker: (context,
                                                    currentValue) async {
                                                  final date =
                                                      await showDatePicker(
                                                          context: context,
                                                          firstDate:
                                                              DateTime(1900),
                                                          initialDate:
                                                              currentValue ??
                                                                  DateTime
                                                                      .now(),
                                                          lastDate:
                                                              DateTime(2100));
                                                  if (date != null) {
                                                    final time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              currentValue ??
                                                                  DateTime
                                                                      .now()),
                                                    );
                                                    return DateTimeField
                                                        .combine(date, time);
                                                  } else {
                                                    return snapshot.data.time
                                                            .toDate() ??
                                                        currentValue;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey[400])),
                                                ),
                                                onSaved: (value) {
                                                  _dateTime = value ??
                                                      snapshot.data.time
                                                          .toDate();
                                                },
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Room Id',
                                                    style: TextStyle(
                                                        fontSize:
                                                            unitHeightValue * 2,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black87),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    onSaved: (value) {
                                                      _roomId = value ?? '';
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 10),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Room password',
                                                    style: TextStyle(
                                                        fontSize:
                                                            unitHeightValue * 2,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black87),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    onSaved: (value) {
                                                      _roomPassword =
                                                          value ?? '';
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 10),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: RaisedButton(
                                            color: Colors.red,
                                            colorBrightness: Brightness.light,
                                            onPressed: () {
                                              formKey.currentState.save();
                                              _updateMatchData(matchId);
                                            },
                                            child: Text('Update match'),
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
                      ));
                } else {
                  return Center(
                    child: Text('Something must be wrong'),
                  );
                }
              }),
        ),
      ),
    );
  }

  _gameTime(time) {
    return DateFormat.yMMMd().add_jm().format(time);
  }

  _updateMatchData(id) async {
    pr.show();
    try {
      String userId = await AuthService().uID();
      CollectionReference matchCollection =
          Firestore.instance.collection('customMatchRooms');
      CollectionReference subscribedGames = Firestore.instance
          .collection('users')
          .document(userId)
          .collection('subscribedGames');

      await matchCollection.document(id).updateData({
        'name': _name,
        'matchNo': _matchNo,
        'maxParticipants': _maxParticipants,
        'perKill': _perKill,
        'prizePool': _prizePool,
        'status': _status,
        'ticket': _ticket,
        'time': _dateTime,
        'roomId': _roomId,
        'roomPassword': _roomPassword
      });

      await subscribedGames.document(id).updateData({
        'name': _name,
        'matchNo': _matchNo,
        'maxParticipants': _maxParticipants,
        'perKill': _perKill,
        'prizePool': _prizePool,
        'status': _status,
        'ticket': _ticket,
        'time': _dateTime,
        'roomId': _roomId,
        'roomPassword': _roomPassword
      });
      pr.hide();
      Toast.show('Match Updated', context);
      Navigator.pop(context);
    } catch (e) {
      pr.hide();
      Toast.show(e.toString(), context);
    }
  }
}
