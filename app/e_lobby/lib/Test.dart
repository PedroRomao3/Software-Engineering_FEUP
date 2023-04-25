import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lobby/Display_users.dart';
import 'package:e_lobby/custom_icons.dart';
import 'package:e_lobby/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'CustomUser.dart';

class TestFirebase extends StatefulWidget {
  CustomUser user = CustomUser.noArgs("");

  @override
  State<TestFirebase> createState() => _TestFirebaseState();

  TestFirebase.a(this.user, {super.key});
}

class IconRow extends StatefulWidget {
  int game = 5;
  final Function(int) onSelectOption;

  IconRow({required this.game, required this.onSelectOption});

  @override
  _IconRowState createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> {
  Color selectedColorOption1 = Colors.black;
  Color selectedColorOption2 = Colors.black;
  double size1 = 30;
  double size2 = 30;

  @override
  void initState() {
    super.initState();
    if (widget.game == 0) {
      size1 = 60;
      size2 = 30;
      selectedColorOption1 = Colors.orangeAccent;
      selectedColorOption2 = Colors.black;
    } else {
      size1 = 30;
      size2 = 60;
      selectedColorOption1 = Colors.black;
      selectedColorOption2 = Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: size1,
          icon: const Icon(CustomIcons.icons8_counter_strike),
          color: selectedColorOption1,
          onPressed: () {
            Future.delayed(Duration.zero, () {
              setState(() {
                size1 = 60;
                size2 = 30;
                selectedColorOption1 = Colors.orangeAccent;
                selectedColorOption2 = Colors.black; // reset Option 2 to white
                widget.onSelectOption(0);
              });
            });

          },
        ),
        IconButton(
          iconSize: size2,
          icon: const Icon(CustomIcons.icons8_league_of_legends__1_),
          color: selectedColorOption2,
          onPressed: () {
            Future.delayed(Duration.zero, () {
              setState(() {
                size1 = 30;
                size2 = 60;
                selectedColorOption1 = Colors.black; // reset Option 1 to white
                selectedColorOption2 = Colors.orangeAccent;
                widget.onSelectOption(1);
              });
            });



          },
        ),
      ],
    );
  }
}

//fill lobby with login user(connected to firebase) when
class _TestFirebaseState extends State<TestFirebase> {
  final CollectionReference _lobbies =
      FirebaseFirestore.instance.collection("Lobby");
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _eloController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image = Image.network(
      "",
      fit: BoxFit.scaleDown,
    );
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    //atualizar dados
    int game = 1;
    int capacity = 0;
    if (documentSnapshot != null) {
      _eloController.text = documentSnapshot['Elo'].toString();
      _nameController.text = documentSnapshot['name'].toString();
      game = documentSnapshot['game'];

      //...
    }

    void handleSelectOption(int game1) {
      Future.delayed(Duration.zero, () {
        setState(() {
          game = game1;
        });
      });
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconRow(
                    game: game,
                    onSelectOption: handleSelectOption,
                  ),
                  SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Text("capacity: "),
                          IconButton(
                              onPressed: () {
                                capacity = 1;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_one)),

                          IconButton(
                              onPressed: () {
                                capacity = 2;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_two)),
                          IconButton(
                              onPressed: () {
                                capacity = 3;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_3)),
                          IconButton(
                              onPressed: () {
                                capacity = 4;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_4)),
                          IconButton(
                              onPressed: () {
                                capacity = 5;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_5)),
                          // Add more items as needed
                        ],
                      )),
                  TextField(
                    controller: _eloController, //grab value
                    decoration: const InputDecoration(labelText: 'Elo'),
                  ),
                  TextField(
                    controller: _nameController, //grab value
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final int elo = int.parse(_eloController.text);
                      final String name = _nameController.text;
                      if (capacity != null) {
                        await _lobbies.doc(documentSnapshot!.id).update({
                          "capacity": capacity,
                          "Elo": elo,
                          "name": name,
                          "game": game,
                        });
                        _eloController.text = '';
                        _nameController.text = '';
                        Navigator.of(context)
                            .pop(); //passamos valores para metodos built in,update linha
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    //atualizar dados
    QuerySnapshot querySnapshot = await _lobbies.get();
    int id = querySnapshot.docs.length + 1;
    _eloController.text = '';
    _nameController.text = '';
    int game = 1;
    int capacity = 0;

    void handleSelectOption(int game1) {
      setState(() {
        game = game1;
      });
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconRow(
                    game: game,
                    onSelectOption: handleSelectOption,
                  ),

                  SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Text("capacity: "),
                          IconButton(
                              onPressed: () {
                                capacity = 1;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_one)),

                          IconButton(
                              onPressed: () {
                                capacity = 2;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_two)),
                          IconButton(
                              onPressed: () {
                                capacity = 3;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_3)),
                          IconButton(
                              onPressed: () {
                                capacity = 4;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_4)),
                          IconButton(
                              onPressed: () {
                                capacity = 5;
                                // Action to be performed on tap
                              },
                              icon: Icon(Icons.looks_5)),
                          // Add more items as needed
                        ],
                      )),
                  TextField(
                    controller: _eloController, //grab value
                    decoration: const InputDecoration(labelText: 'Elo'),
                  ),
                  TextField(
                    controller: _nameController, //grab value
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      final int elo = int.parse(_eloController.text);
                      final String name = _nameController.text;
                      if (capacity != null) {
                        List<Map<String, dynamic>> messages = [
                          {'senderName': "E_lobBy Username", 'text': "message"},
                        ];
                        await _lobbies.add({
                          "messages": messages,
                          "lobbyId": id,
                          "capacity": capacity,
                          "Elo": elo,
                          "name": name,
                          "game": game,
                          "creator": widget.user.toMap(),
                          "users": FieldValue.arrayUnion(
                              [CustomUser.userEmail("E_LobBy username","user email").toMap()]) //custom user
                        });
                        _idController.text = '';
                        _capacityController.text = '';
                        _eloController.text = '';
                        _nameController.text = '';
                        Navigator.pop(context);

                        //passamos valores para metodos built in,update linha
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String userId) async {
    //apagar linhas , ou seja utilizadores
    await _lobbies.doc(userId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a lobby')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'button1',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Icon(Icons.logout_rounded),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 80,
            child: FloatingActionButton(
              heroTag: 'button2',
              onPressed: () => _create(),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _create(),
      //   child: const Icon(Icons
      //       .add), //ao pressionar botão adicionar valores dos controladores á BD
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //botão no meio
      body: StreamBuilder(
        //função que ajuda a manter uma conxão persistente com a base de dados
        stream: _lobbies.snapshots(), //build connection com tabela na firebase
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          //snapshot que tem toda a DAta
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name'].toString()),
                    subtitle: Text(
                        "Missing Players: ${documentSnapshot['capacity'] - (documentSnapshot['users'] as List).length + 1}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => const Text("data"),
                          icon: Icon(
                            CustomIcons
                                .customIconList[documentSnapshot["game"]],
                            color: Colors.deepOrange,
                          ),
                        ),
                        documentSnapshot['creator']['email'] == widget.user.email
                            ? IconButton(
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(Icons.edit),
                              )
                            : SizedBox.shrink(),
                        documentSnapshot['creator']['email'] == widget.user.email
                            ? IconButton(
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete),
                              )
                            : SizedBox.shrink(),
                        TextButton(
                          child: const Text("Join"),
                          onPressed: () async {
                            if(documentSnapshot['capacity'] - (documentSnapshot['users'] as List).length > -1){
                              await _lobbies.doc(documentSnapshot!.id).update({
                                "users": FieldValue.arrayUnion(
                                    [widget.user.toMap()]) //custom user
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DisplayUsersPage(
                                        documentSnapshot!.id,
                                        widget
                                            .user)), //DisplayUsersPage(documentSnapshot!.id, widget.user)
                              );
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(

                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text('Lobby is full')));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
