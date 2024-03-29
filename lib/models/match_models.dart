import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  String game;
  String name;
  String status;
  int ticket;
  String imageUrl;
  String map;
  String matchNo;
  int maxParticipants;
  int perKill;
  String prizePool;
  String id;
  Timestamp time;
  bool resultOut;
  String roomId;
  String roomPassword;
  String description;
  int noOfGroups;

  Matches(
      {this.game,
      this.name,
      this.status,
      this.ticket,
      this.imageUrl,
      this.map,
      this.matchNo,
      this.maxParticipants,
      this.perKill,
      this.prizePool,
      this.id,
      this.time,
      this.resultOut,
      this.roomId,
      this.roomPassword,
      this.description,
      this.noOfGroups});
}

class MyMatches {
  String game;
  String name;
  String imageUrl;
  String matchNo;
  String prizePool;
  String id;
  String time;

  MyMatches({
    this.game,
    this.name,
    this.imageUrl,
    this.matchNo,
    this.prizePool,
    this.id,
    this.time,
  });
}

class Results {
  String gameId;
  String kills;
  String reward;

  Results({this.gameId, this.kills, this.reward});
}

class RoomDetailsModel {
  String roomId;
  String roomPassword;
  Timestamp time;
  String id;

  RoomDetailsModel({this.roomId, this.roomPassword, this.time, this.id});
}
