import 'package:earth_hack/utils.dart';
import 'package:flutter/material.dart';
import 'package:earth_hack/location.dart';
import 'package:earth_hack/chat.dart';
import 'package:earth_hack/Home.dart';
import 'package:earth_hack/farm.dart';
import 'package:earth_hack/utils.dart';
import 'package:earth_hack/widgets/nav_drawer.dart';

void main() => runApp(ConsumerApp());

class ConsumerApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ConsumerApp> {
  TabController tabController;
  int _selectedIndex = 0;

  final List<Widget> _children = [MainPage(), Location(), Chat()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nearby Farms',
        home: Scaffold(
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text('Nearby Farms'),
            backgroundColor: primaryColor,
          ),
          body: _children[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Locate'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                title: Text('Chat'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: primaryColor,
            onTap: _onItemTapped,
          ),
        ));
  }
}
