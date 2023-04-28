import 'package:e_lobby/BirthdayForm.dart';
import 'package:e_lobby/custom_icons.dart';
import 'package:e_lobby/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_lobby/CustomUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class RankSelectionDialog extends StatelessWidget {
  const RankSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a rank'),
      children: [
        //AQUI DEVERIAMOS CRIAR UMA TABLE NA DATABASE COM O NOME E IMG PARA DAR DISPLAY E ESCOLHER DE TODOS
        ListTile(
          leading: const Icon(Icons.grade),
          title: const Text('Rank 1'),
          onTap: () => Navigator.pop(context, 1),
        ),
      ],
    );
  }
}

class PlayerInfoPage extends StatefulWidget {
  const PlayerInfoPage({super.key, required this.string});
  final String string;

  @override
  _PlayerInfoPageState createState() => _PlayerInfoPageState();
}

class _PlayerInfoPageState extends State<PlayerInfoPage> {
  final storage = FirebaseStorage.instance;
  late String imageUrl;

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
        backgroundColor: Color(0xFF501467),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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

                          const SizedBox(height: 20),
                          BirthdayForm(
                            onBirthdaySelected: _handleBirthdaySelected,
                          ),
                          const SizedBox(height: 40),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                          InkWell(
                            onTap: () async {
                              final selectedRank = await showDialog<int>(
                                context: context,
                                builder: (context) => const RankSelectionDialog(),
                              );
                              if (selectedRank != null) {
                                setState(() {
                                  _rank1 = selectedRank;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                const Icon(size: 100, CustomIcons.icons8_league_of_legends__1_),
                                const SizedBox(height: 20),
                                Text(_rank1 == null ? 'Select rank' : 'Rank $_rank1'),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              final selectedRank = await showDialog<int>(
                                context: context,
                                builder: (
                                    context) => const RankSelectionDialog(),
                              );
                              if (selectedRank != null) {
                                setState(() {
                                  _rank2 = selectedRank;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                const Icon(size: 100,CustomIcons.icons8_counter_strike),
                                const SizedBox(height: 20),
                                Text(_rank2 == null ? 'Select rank' : 'Rank $_rank2'),
                              ],
                            ),
                          ),
                            ]),


                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _saveCustomUser,
                            child: Text('Save'),
                          ),
                        ])))));
  }
}
