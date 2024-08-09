import "package:first_app/Cubits/todos_cubit.dart";
import "package:first_app/Repository/todos_repo.dart";
import "package:first_app/View/home_page.dart";
import "package:flutter/material.dart";
import 'dart:async';

import "package:flutter_bloc/flutter_bloc.dart";

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
        home: BlocProvider(
            create: (context) => TodosCubit(), child: const HomePage()));
  }
}
