import 'package:cloud_firestore/cloud_firestore.dart';
class CustomUser{
  String id;
  final String name;
//futuro user
  CustomUser({
    this.id = '',
    required this.name,

});
  Map<String,dynamic> toJson() => {
    'id' : id,
    'name' : name,
  };
  static CustomUser fromJson(Map<String,dynamic> json) => CustomUser(
    id: json['id'],
    name: json['name'],
  );
}