import "package:first_app/home_page.dart";
import "package:flutter/material.dart";
import 'dart:async';

Future<void> main() async {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Home Page",
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 162, 101, 226)),
        home: const HomePage());
  }
}
