import 'package:flutter/material.dart';
import 'package:readlytic/config/app_theme.dart';
import 'package:readlytic/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(Colors.lightGreen, true),
      home: const HomePage(),
    );
  }
}
