import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  String game;
  String name;
  String status;
  int ticket;
  String imageUrl;
  String map;
  String matchNo;
  String maxParticipants;
  String perKill;
  String prizePool;
  String id;
  Timestamp time;

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
      this.time});
}
