import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String username = "";
  DateTime birthday = DateTime(2023, 4, 20, 12, 0, 0);
  String? discordId = "";
  String email = "";
  bool isAdmin = false;
  String language = "english";
  List<int> ranks = [0, 0];

  CustomUser(this.birthday, this.discordId, this.email, this.isAdmin,
      this.language, this.username, this.ranks);

  CustomUser.info(
      this.username, this.birthday, this.discordId, this.language, this.ranks);


  CustomUser.noArgs(this.username);
  CustomUser.userEmail(this.username,this.email);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'discordId': discordId,
      'birthday': birthday,
      'language': language,
      'ranks': ranks,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      (map['birthday'] as Timestamp).toDate(),
      map['discordUserId'],
      map['email'],
      map['isAdmin'],
      map['language'],
      map['username'],
      List<int>.from(map['ranks']),
    );
  }
}
