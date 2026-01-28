import 'package:eventify/pages/detail_page.dart';
import 'package:eventify/pages/signup.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart'; // obavezno uključi fajl gde se nalazi Home widget
import 'pages/bottomnav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  SignUp(), // dodali smo const
    );
  }
}
