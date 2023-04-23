import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_lobby/CustomUser.dart';

class DisplayUsersPage extends StatelessWidget {
  final String lobbyId;
  final CustomUser user;

  const DisplayUsersPage(this.lobbyId, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await FirebaseFirestore.instance.collection('Lobby').doc(lobbyId).update({
              "users": FieldValue.arrayRemove([user.toMap()])
            });
            Navigator.pop(context);
          },
        ),
        title: const Text('Lobby Users'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Lobby').doc(lobbyId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(!snapshot.hasData || !snapshot.data!.exists ){
            Navigator.pop(context);
            return const Center(child: Text("Don't exist"));
          }
          if ( !(snapshot.data!.data() as Map<String, dynamic>).containsKey('users')) {
            return  Center(child: Text(lobbyId!));
          }

          final users = List<Map<String, dynamic>>.from(snapshot.data!.get('users'));

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              CustomUser user = CustomUser.fromMap(users[index]);
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
