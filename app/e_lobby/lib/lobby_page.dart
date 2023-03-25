import 'package:flutter/material.dart';

class Lobby {
  final String name;
  final List<CustomUser> users;

  Lobby({required this.name, this.users = const []});

  Lobby addUser(CustomUser user) {
    return Lobby(name: name, users: [...users, user]);
  }
  String getName(){
    return name;
  }
  String getFirstUserEmail(){
    return users[0].getName();
  }

  Lobby removeUser(CustomUser user) {
    return Lobby(
      name: name,
      users: users.where((u) => u.id != user.id).toList(),
    );
  }
}

class CustomUser {
  final int id;
  final String name;


  CustomUser({required this.id, required this.name});
  String getName(){
    return name;
  }
}

class LobbyPage extends StatelessWidget {
  final CustomUser user1;
  const LobbyPage({Key? key, required this.user1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobbies'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Lobby lobby1 = Lobby(name: "lobby1");
              lobby1 = lobby1.addUser(user1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LobbyDetailsPage(lobby: lobby1),
                ),
              );
            },
            child: const Text('Lobby 1'),
          ),
          ElevatedButton(
            onPressed: () {
              Lobby lobby2 = Lobby(name: "lobby2");
              lobby2 =  lobby2.addUser(user1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LobbyDetailsPage(lobby: lobby2),
                ),
              );
            },
            child: const Text('Lobby 2'),
          ),
          ElevatedButton(
            onPressed: () {
              Lobby lobby3 = Lobby(name: "lobby3");
              lobby3 = lobby3.addUser(user1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LobbyDetailsPage(lobby: lobby3),
                ),
              );
            },
            child: const Text('Lobby 3'),
          ),
        ],
      ),
    );
  }
}

class LobbyDetailsPage extends StatelessWidget {
  final Lobby lobby;

  const LobbyDetailsPage({Key? key, required this.lobby}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lobby.getName()),
      ),
      body: Center(
        child: Text('User:${lobby.getFirstUserEmail()}' ),
      ),
    );
  }
}