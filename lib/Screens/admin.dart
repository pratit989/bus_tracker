import 'package:flutter/material.dart';


class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _currentIndex = 0;

  final List<Text> _titles = [
    // Feed
    const Text(
      'Bus Settings',
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
    Container(),
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
              icon: Icon(Icons.settings_outlined), label: 'Bus Settings', activeIcon: Icon(Icons.settings)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile', activeIcon: Icon(Icons.person)),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
