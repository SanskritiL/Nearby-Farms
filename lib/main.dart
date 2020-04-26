import 'package:earth_hack/utils.dart';
import 'package:flutter/material.dart';
import 'package:earth_hack/customer.dart';
import 'package:earth_hack/utils.dart';
import 'package:earth_hack/farmer.dart';

void main() => runApp(MyApp());
enum Usertype { farmer, consumer }
Usertype _type = Usertype.consumer;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Nearby Farms'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: const Text('Consumer 👩🏽'),
            leading: Radio(
              value: Usertype.consumer,
              groupValue: _type,
              onChanged: (Usertype value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Farmer 👨🏽‍🌾'),
            leading: Radio(
              value: Usertype.farmer,
              groupValue: _type,
              onChanged: (Usertype value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.launch),
              tooltip: 'Launch',
              onPressed: () {
                if (_type == Usertype.consumer) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ConsumerApp()),
                  );
                } else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new Farmer()),
                  );
                }
              }),
        ],
      ),
    );
  }
}
