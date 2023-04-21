import 'package:e_lobby/BirthdayForm.dart';
import 'package:e_lobby/main.dart';
import 'package:flutter/material.dart';
import 'package:e_lobby/CustomUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PlayerInfoPage extends StatefulWidget {
  const PlayerInfoPage({super.key, required this.string});
  final String string;

  @override
  _PlayerInfoPageState createState() => _PlayerInfoPageState();
}

class _PlayerInfoPageState extends State<PlayerInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  String _discordId = '';
  String _language = '';
  String _username = '';
  int _rank1 = 0;
  int _rank2 = 0;

  void _handleBirthdaySelected(DateTime birthday) {
    setState(() {
      _selectedDate = birthday;
    });
  }

  void _saveCustomUser() {
    if (_formKey.currentState!.validate()) {
      CustomUser user = CustomUser.info(
          _username, _selectedDate, _discordId, _language, [_rank1, _rank2]);
      // do something with playerInfo object, e.g. save to database
      final CollectionReference customUsersCollection =
      FirebaseFirestore.instance.collection('users');
      Map<String, dynamic> userMap = {
        'birthday': user.birthday,
        'discordUserID': user.discordId,
        'email': widget.string,
        'isAdmin':user.isAdmin,
        'language': user.language,
        'ranks' : user.ranks,
        'username' : user.username
      };
      customUsersCollection.doc().set(userMap);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Player Info'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'username',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _username = value;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Discord ID',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Discord ID';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _discordId = value;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Language',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your language';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _language = value;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Rank in Video Game 1',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your rank in Video Game 1';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _rank1 = int.parse(value);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Rank in Video Game 2',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your rank in Video Game 2';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _rank2 = int.parse(value);
                            },
                          ),
                          BirthdayForm(
                            onBirthdaySelected: _handleBirthdaySelected,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _saveCustomUser,
                            child: Text('Save'),
                          ),
                        ])))));
  }
}
