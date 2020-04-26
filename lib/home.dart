import 'package:earth_hack/utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(        
        child: new Image.asset('assets/home_prototype.png',
          width: size.width,
          height: size.height,
          fit: BoxFit.cover,         
        ),
      ),
    );    
  }
}
