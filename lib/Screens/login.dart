import 'package:bus_tracker/Screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bus_tracker/Screens/home.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String password;
  late String email;
  // Initially password is obscure
  bool _obscureText = true;
  IconData _icon = Icons.lock_outline;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _loginKey = GlobalKey<FormState>();

  // var _email = TextEditingController(text: 'Email');
  // var _password = TextEditingController(text: 'Password');

  @override
  Widget build(BuildContext context) {
    final authInstance = context.read<FirebaseAuth>();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0, 0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize:
                            MediaQuery.of(context).size.height * 0.03),
                      ),
                    ),
                    Form(
                        key: _loginKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid email address.';
                                  } else {
                                    email = value;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: 'Email'
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid password.';
                                  } else if (value.length < 6) {
                                    return 'Password should be at least 6 characters long';
                                  } else {
                                    password = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.vpn_key),
                                    suffixIcon: IconButton(
                                      icon: Icon(_icon),
                                      onPressed: () {
                                        if(_obscureText){
                                          _obscureText = false;
                                          _icon = Icons.lock_open;
                                        } else {
                                          _obscureText = true;
                                          _icon = Icons.lock_outline;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    hintText: 'Password'
                                ),
                              ),
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.05),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.04,
                              bottom:
                              MediaQuery.of(context).size.height * 0.04),
                          child: FloatingActionButton.extended(
                              onPressed: () async {
                                if (_loginKey.currentState!.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')));
                                  authInstance.signInWithEmailAndPassword(
                                      email: email, password: password)
                                      .then((value) {
                                    final snackBar = SnackBar(
                                      duration: const Duration(seconds: 3),
                                      content: Text(
                                        "Welcome ${value.user!.displayName.toString()}",
                                        style:
                                        const TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.black,
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Provider<User>(
                                                  create: (_) => value.user!,
                                                  child: const Home(),
                                                )),
                                            (route) => false);
                                  }).onError((error, stackTrace) {
                                    final snackBar = SnackBar(
                                      duration: const Duration(seconds: 3),
                                      content: Text(
                                        error.toString(),
                                        style:
                                        const TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.black,
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  });
                                }
                              }, label: const Text('Login'),)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
