import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lobby/Test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_lobby/CustomUser.dart';
import 'package:e_lobby/RegistrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //garartir binding
  await Firebase.initializeApp(); //ligação ao firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(), //mudar para login otv
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firebase init
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User account created successfully! ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Failed to create user account: $e');
    }
  }

  //Login Function
  static Future<User?> loginUsingEmailPasword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('No User Found. Try Again!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Check Your Credentials And Try Again!')));
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    //create the textfilled ctrl
    TextEditingController _emailCtrl = TextEditingController();
    TextEditingController _pwCtrl = TextEditingController();
    Future<void> forgotPassword(
        {required String email, required BuildContext context}) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        await auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Password reset link sent to your email!')));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: Text('No user found with that email!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Failed to send password reset email!')));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login to E_LobBy ",
                style: TextStyle(
                  color: Color(0xFF7EA5C5),
                  fontSize: 44.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 44.0,
              ),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "User Email",
                  prefixIcon: Icon(Icons.mail, color: Color(0xFF7EA5C5)),
                  hintStyle: TextStyle(color: Color(0xFF7EA5C5)),
                ),
                style: const TextStyle(color: Color(0xFF7EA5C5)),
              ),
              const SizedBox(
                height: 26.0,
              ),
              TextField(
                controller: _pwCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "User Password",
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF7EA5C5)),
                  hintStyle: TextStyle(color: Color(0xFF7EA5C5)),
                ),
                style: const TextStyle(color: Color(0xFF7EA5C5)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Forgot Password'),
                          content: TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('CANCEL'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await forgotPassword(
                                    email: _emailCtrl.text, context: context);
                                Navigator.pop(context);
                              },
                              child: const Text('SEND EMAIL'),
                            ),
                          ],
                        );
                      });
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF7EA5C5)),
                ),
              ),
              const SizedBox(
                height: 88.0,
              ),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Color(0xFF7EA5C5),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    User? user = await loginUsingEmailPasword(
                        email: _emailCtrl.text,
                        password: _pwCtrl.text,
                        context: context);
                    print(user?.email);
                    if (user != null) {
                      final QuerySnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .where('email', isEqualTo: user.email)
                          .get();

                      final List<DocumentSnapshot> documents = snapshot.docs;
                      CustomUser cUser = CustomUser.noArgs("username");
                      if (documents.isNotEmpty) {
                        // Retrieve the first document, assuming the email address is unique
                        final DocumentSnapshot userDoc = documents.first;
                        // Convert the document data to a custom user object
                        cUser = CustomUser.fromMap(
                            userDoc.data() as Map<String, dynamic>);
                        // Do something with the user object
                      } else {
                        // No user with the given email address exists in the collection
                      }

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TestFirebase.a(cUser)));
                    }
                  },
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Color(0xFF7EA5C5),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                  },
                  child: const Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
