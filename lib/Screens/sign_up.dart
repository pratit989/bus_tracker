import 'package:bus_tracker/Screens/Login.dart';
import 'package:bus_tracker/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Item {
  const Item(this.name, this.icon);

  final String name;
  final Icon icon;
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String password;
  late String name;
  late String phoneNumber;

  // Initially password is obscure
  bool _obscureText = true;
  IconData _icon = Icons.lock_outline;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _loginKey = GlobalKey<FormState>();

  Item? selectedUser;
  List<Item> users = <Item>[
    const Item(
        'Driver/Conductor',
        Icon(
          Icons.drive_eta,
          color: Colors.grey,
        )),
    const Item(
        'Passenger',
        Icon(
          Icons.person,
          color: Colors.grey,
        )),
  ];

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authInstance = context.read<FirebaseAuth>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                            MediaQuery.of(context).size.height * 0.03),
                        child: Text(
                          'Sign Up',
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
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    if (value!.isEmpty || value == 'Name') {
                                      return 'Please enter a valid name.';
                                    } else {
                                      name = value;
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: 'Name',
                                  ),
                                  controller: _name,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value == 'Email' ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email.';
                                    } else {
                                      email = value;
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      hintText: 'Email'),
                                  controller: _email,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  validator: (value) {
                                    if (value!.isEmpty || value == 'Password') {
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
                                          if (_obscureText) {
                                            _obscureText = false;
                                            _icon = Icons.lock_open;
                                          } else {
                                            _obscureText = true;
                                            _icon = Icons.lock_outline;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      hintText: 'Password'),
                                  controller: _password,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: DropdownButtonFormField<Item>(
                                  validator: (value) =>
                                      value == null ? 'field required' : null,
                                  isExpanded: true,
                                  hint: const Text("Select User Type"),
                                  value: selectedUser,
                                  onChanged: (Item? value) {
                                    setState(() {
                                      selectedUser = value!;
                                    });
                                  },
                                  items: users.map((Item user) {
                                    return DropdownMenuItem<Item>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          user.icon,
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            user.name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                      Builder(
                        builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                if (_loginKey.currentState!.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')));
                                  authInstance.createUserWithEmailAndPassword(
                                      email: email, password: password)
                                    .then((value) {
                                      value.user!.updateDisplayName(name).then((_) {
                                        final snackBar = SnackBar(
                                          duration: const Duration(seconds: 3),
                                          content: Text(
                                            "Welcome $name",
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
                                      });
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
                              },
                              label: const Text('Sign Up'),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
