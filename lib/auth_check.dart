import 'package:bus_tracker/Screens/home.dart';
import 'package:bus_tracker/Screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseAuth>();
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? const Home() : const SignUp();
        }

        return const CircularProgressIndicator(
          color: Colors.blue,
        );
      },
    );
  }
}
