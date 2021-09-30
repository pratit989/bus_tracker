// Flutter
import 'package:bus_tracker/Screens/sign_up.dart';
import 'package:bus_tracker/auth_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initialiseFirebaseWithAppCheck() {
    return Firebase.initializeApp().then((value) {
      FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialiseFirebaseWithAppCheck(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("There was an issue initialising Firebase. "
                  "The following Error occurred: ${snapshot.error}"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider<FirebaseAuth>(
            create: (context) => FirebaseAuth.instance,
            child: MaterialApp(
              title: 'Bus Tracker',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const AuthCheck(),
              routes: {
                '/SignUp': (context) => const SignUp(),
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator(
          color: Colors.blue,
        );
      },
    );
  }
}
