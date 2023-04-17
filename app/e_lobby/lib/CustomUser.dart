import 'package:cloud_firestore/cloud_firestore.dart';
class CustomUser{
  DateTime birthday;
  String discordId;
  String email;
  bool isAdmin;
  String id;
  final String username;

  CustomUser(this.birthday, this.discordId, this.email, this.isAdmin, this.id,
      this.username); //futuro user

  Map<String,dynamic> toJson() => {
    'id' : id,
    'name' : username,
  };

}