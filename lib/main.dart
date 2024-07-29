import "package:first_app/homepage.dart";
import "package:flutter/material.dart";
void main() {
  runApp(const Home()); // const eklenebilir Home() başına 
}

class Home extends StatelessWidget {
    const Home({super.key});

  @override 
  Widget build(BuildContext context) {
    return  MaterialApp (
      title: "Home Page", 
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromARGB(255, 162, 101, 226)),
      home:   HomePage()
    ); 
  }
}

