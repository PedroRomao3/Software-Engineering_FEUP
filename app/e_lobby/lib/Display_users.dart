import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_lobby/CustomUser.dart';

class DisplayUsersPage extends StatelessWidget {
  final String lobbyId;

  final CustomUser user;

  const DisplayUsersPage(this.lobbyId, this.user);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await FirebaseFirestore.instance
            .collection('Lobby')
            .doc(lobbyId)
            .update({
          "users": FieldValue.arrayRemove([user.toMap()])
        });
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF7EA5C5),
          heroTag: 'button1',
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatRoom(lobbyId, user)));
          },
          child: const Icon(Icons.chat),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF7EA5C5),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white, // Change the color of the icon
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Lobby')
                  .doc(lobbyId)
                  .update({
                "users": FieldValue.arrayRemove([user.toMap()])
              });
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Lobby Users',
            style: TextStyle(
              color: Colors.white, // Change the color of the title
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Lobby')
              .doc(lobbyId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              Navigator.pop(context);
              return const Center(child: Text("Don't exist"));
            }
            if (!(snapshot.data!.data() as Map<String, dynamic>)
                .containsKey('users')) {
              return Center(child: Text(lobbyId!));
            }

            final users =
                List<Map<String, dynamic>>.from(snapshot.data!.get('users'));

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                CustomUser user = CustomUser.fromMap(users[index]);
                return ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    user.username,
                    style: const TextStyle(color: Color(0xFF7EA5C5)),
                  ),
                  subtitle: Text(
                    user.email,
                    style: const TextStyle(color: Color(0xFF7EA5C5)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String lobbyId;
  final CustomUser user;

  const ChatRoom(this.lobbyId, this.user);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Lobby')
          .doc(widget.lobbyId)
          .update({
        "messages": FieldValue.arrayUnion([
          {
            'senderId': widget.user.email,
            'senderName': widget.user.username,
            'text': text,
            'createdAt': DateTime.now().toUtc()
          }
        ])
      });
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7EA5C5),
        title: const Text(
          'Chat Room',
          style: TextStyle(
              color: Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Lobby')
            .doc(widget.lobbyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            Navigator.pop(context);
            return const Center(child: Text("Don't exist"));
          }
          if (!(snapshot.data!.data() as Map<String, dynamic>)
              .containsKey('messages')) {
            return Center(child: Text('No messages yet.'));
          }

          final messages =
              List<Map<String, dynamic>>.from(snapshot.data!.get('messages'));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(
                        message['senderName'],
                        style: const TextStyle(color: Color(0xFF7EA5C5)),
                      ),
                      subtitle: Text(
                        message['text'],
                        style: const TextStyle(color: Color(0xFF7EA5C5)),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Color(0xFF7EA5C5),
                        ),
                        border: InputBorder.none, // remove the underline
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // add padding to make the background color visible
                      ),
                      style: const TextStyle(
                        color: Color(0xFF7EA5C5), // set the text color to white
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    )
                    ,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // set the background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xFF7EA5C5),
                      ),
                      onPressed: _sendMessage,
                    ),
                  )
                  ,
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
