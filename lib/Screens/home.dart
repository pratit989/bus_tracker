import 'package:bus_tracker/Screens/login.dart';
import 'package:bus_tracker/Screens/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Text> _titles = [
    // Feed
    const Text(
      'Map',
      style: TextStyle(color: Colors.black),
    ),
    // Chat
    const Text(
      'Profile',
      style: TextStyle(color: Colors.black),
    ),
  ];

  final List<Widget> _pages = [
    // Activity Widget
    const MapSample(),
    // Chat Widget
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _titles[_currentIndex],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Maps', activeIcon: Icon(Icons.map)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile', activeIcon: Icon(Icons.person)),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout_outlined), label: 'Sign Out', activeIcon: Icon(Icons.logout)),
        ],
      ),
    );
  }

  Future<void> onTabTapped(int index) async {
    index == 2 ? await FirebaseAuth.instance.signOut() : setState(() {
      _currentIndex = index;
    });
    index == 2 ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false) : null;
  }
}
