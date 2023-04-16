import 'package:e_lobby/lobby_page.dart';
import 'package:e_lobby/Test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirebase extends StatefulWidget {
  const TestFirebase({Key? key}) : super(key: key);

  @override
  State<TestFirebase> createState() => _TestFirebaseState();
}

class _TestFirebaseState extends State<TestFirebase> {
  final CollectionReference _lobbies = FirebaseFirestore.instance.collection("users");
  /*
  await _users.add({"name": name, "id": id});
  await _users.update({"name": name, "id": id});
  await _users.doc(productId).delete();
  */
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {//atualizar dados
    if (documentSnapshot != null) {

      _emailController.text = documentSnapshot['email'].toString();//grab values
      _usernameController.text = documentSnapshot['username'].toString();
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
                  controller: _emailController,//grab value
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _usernameController,//grab value
                  decoration: const InputDecoration(
                    labelText: 'username',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    final String email = _emailController.text ;//guardar valores
                    final String username = _usernameController.text;
                    if (username != null) {

                      await _lobbies
                          .doc(documentSnapshot!.id)
                          .update({"email": email, "username": username});//passamos valores para metodos built in,update linha
                      _emailController.text = '';
                      _usernameController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {//criar dados ou seja nova linha
    if (documentSnapshot != null) {

      _emailController.text = documentSnapshot['email'].toString();//grab values
      _usernameController.text = documentSnapshot['username'].toString();
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
                  controller: _emailController,//grab value
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _usernameController,//grab value
                  decoration: const InputDecoration(
                    labelText: 'username',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    final double? email = double.tryParse(_emailController.text);//guardar valores
                    final double? username =
                    double.tryParse(_usernameController.text);
                    if (email != null) {

                      await _lobbies.add({"email": email,"username": username});
                      _emailController.text = '';
                      _usernameController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }
  Future<void> _delete(String userId) async {//apagar linhas , ou seja utilizadores
    await _lobbies.doc(userId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a user')));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),//ao pressionar botão adicionar valores dos controladores á BD
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,//botão no meio
      body: StreamBuilder(//função que ajuda a manter uma conxão persistente com a base de dados
        stream: _lobbies.snapshots(), //build connection com tabela na firebase
        builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){//snapshot que tem toda a DAta
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,//docs=linhas na tabela
              itemBuilder: (context,index){
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return  Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['email'].toString()),//aceder ao nome do user e dar display do firebase
                    subtitle: Text(documentSnapshot['username'].toString()),//aceder ao id do user '' ''
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(onPressed: () => _update(documentSnapshot), icon: Icon(Icons.edit)),//atualizar dados temos de passar a informação da tabela
                          IconButton(onPressed: () => _delete(documentSnapshot.id), icon: Icon(Icons.delete)),//para apagar só e preciso passar o id do que queremos apagar(automático)
                        ],
                      ),
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
