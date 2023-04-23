import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lobby/LobbyPage.dart';
import 'package:e_lobby/custom_icons.dart';
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
class MyWidget extends StatefulWidget {
  int game = 5;
  final Function(int) onSelectOption;
  MyWidget({required this.game  , required this.onSelectOption});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Color selectedColorOption1 = Colors.white;
  Color selectedColorOption2 = Colors.white;
  @override
  void initState() {

    super.initState();
    if(widget.game==0){
      selectedColorOption1 = Colors.orangeAccent;
      selectedColorOption2 = Colors.white;
    }
    else{
      selectedColorOption1 = Colors.white;
      selectedColorOption2 = Colors.orangeAccent;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 90,
      child: ListView(
        children: [
          ListTile(
            title: Text('CS'),
            tileColor: selectedColorOption1,
            onTap: () {
              setState(() {
                selectedColorOption1 = Colors.orangeAccent;
                selectedColorOption2 = Colors.white; // reset Option 2 to white
                widget.onSelectOption(0);
              });
            },
          ),
          ListTile(
            title: Text('LOL'),
            tileColor: selectedColorOption2,
            onTap: () {
              setState(() {
                selectedColorOption1 = Colors.white; // reset Option 1 to white
                selectedColorOption2 = Colors.orangeAccent;
                widget.onSelectOption(1);
              });
            },
          ),
        ],
      ),
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
    int game=1;
    if (documentSnapshot != null) {
      _idController.text = documentSnapshot['lobbyId'].toString(); //grab values
      _capacityController.text = documentSnapshot['capacity'].toString();
      _eloController.text = documentSnapshot['Elo'].toString();
      _nameController.text = documentSnapshot['name'].toString();
      game = documentSnapshot['game'];

      //...
    }

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
                  TextField(
                    controller: _idController, //grab value
                    decoration: const InputDecoration(labelText: 'lobbyId'),
                  ),

                  MyWidget(
                      game:game,
                      onSelectOption: handleSelectOption,
                  ),

                  TextField(
                    controller: _capacityController, //grab value
                    decoration: const InputDecoration(
                      labelText: 'capacity',
                    ),
                  ),
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
                      final String id = _idController.text; //guardar valores
                      final int capacity = int.parse(_capacityController.text);
                      final int elo = int.parse(_eloController.text) ;
                      final String name = _nameController.text;
                      if (capacity != null) {
                        await _lobbies.doc(documentSnapshot!.id).update({
                          "lobbyId": id,
                          "capacity": capacity,
                          "Elo": elo,
                          "name": name,
                          "game": game,});
                        _idController.text = '';
                        _capacityController.text = '';
                        _eloController.text = '';
                        _nameController.text = '';
                        Navigator.of(context).pop();//passamos valores para metodos built in,update linha

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
    //criar dados ou seja nova linha
    if (documentSnapshot != null) {
      _idController.text = documentSnapshot['lobbyId'].toString(); //grab values
      _capacityController.text = documentSnapshot['capacity'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _idController, //grab value
                  decoration: const InputDecoration(labelText: 'id'),
                ),
                TextField(
                  controller: _capacityController, //grab value
                  decoration: const InputDecoration(
                    labelText: 'capacity',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String id = _idController.text; //guardar valores
                    final String capacity = _capacityController.text;
                    if (id != null) {
                      await _lobbies.add({"lobbyId": id, "capacity": capacity});
                      _idController.text = '';
                      _capacityController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons
            .add), //ao pressionar botão adicionar valores dos controladores á BD
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //botão no meio
      body: StreamBuilder(
        //função que ajuda a manter uma conxão persistente com a base de dados
        stream: _lobbies.snapshots(), //build connection com tabela na firebase
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          //snapshot que tem toda a DAta
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length ,
              itemBuilder: (context, index) {

                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index ];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['lobbyId'].toString()),
                    subtitle: Text("Missing Players: ${documentSnapshot['capacity']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        documentSnapshot['game'] == 0 ? IconButton(
                          onPressed: () => _update(documentSnapshot),
                          icon: const Icon(CustomIcons.icons8_counter_strike,color: Colors.deepOrange,),
                        ) : IconButton(
                          onPressed: () => _update(documentSnapshot),
                          icon: const Icon(CustomIcons.icons8_league_of_legends__1_,color: Colors.deepOrange,),
                        )
                        ,

                        IconButton(
                          onPressed: () => _update(documentSnapshot),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _delete(documentSnapshot.id),
                          icon: const Icon(Icons.delete),
                        ),
                        TextButton(
                          child: const Text("Join"),
                          onPressed: () async {
                            await _lobbies.doc(documentSnapshot!.id).update({
                              "users": FieldValue.arrayUnion(
                                  [widget.user.toMap()]) //custom user
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayUsersPage(
                                      documentSnapshot!.id, widget.user)),
                            );
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
