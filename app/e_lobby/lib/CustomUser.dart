import 'package:cloud_firestore/cloud_firestore.dart';
class CustomUser{
  String username = "";
  DateTime birthday = DateTime(2023, 4, 20, 12, 0, 0);
  String discordId = "";
  String email = "";
  bool isAdmin = false;
  String language = "english";
  List<int> ranks = [0,0];

  CustomUser(this.birthday, this.discordId, this.email, this.isAdmin,
      this.language, this.username, this.ranks);

  CustomUser.noArgs(this.username);
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'discordId':discordId,
      'birthday':birthday,
      'language':language,
      'ranks':ranks,
    };
  }
}