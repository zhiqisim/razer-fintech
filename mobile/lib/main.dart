import 'package:flutter/material.dart';

import './pages/login.dart' as login;
import './pages/stores.dart' as stores;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Apps',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new login.Login(title: "Login"),
    );
  }
}
