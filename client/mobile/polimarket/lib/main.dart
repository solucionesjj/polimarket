import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ':: Accede a PoliMarket ::',
      home: LoginPage(),
    );
  }
}
