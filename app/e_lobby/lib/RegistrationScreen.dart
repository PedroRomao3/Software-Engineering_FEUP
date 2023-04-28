import 'package:e_lobby/player_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _email = '';
  String _password = '';
  String _error = '';

  Future<void> _registerUser() async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final User user = userCredential.user!;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayerInfoPage( string: user.email!,)),
      );
       // navigate back to previous screen
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _error = 'The email address is already in use.';
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          _error = 'The password provided is too weak.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _error = 'The email address is badly formatted';
        });
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      backgroundColor: Color(0xFF501467),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {

                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
