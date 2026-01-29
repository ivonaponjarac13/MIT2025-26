import 'package:eventify/admin/upload_event.dart';
import 'package:eventify/pages/detail_page.dart';
import 'package:eventify/pages/signup.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart'; // obavezno uključi fajl gde se nalazi Home widget
import 'pages/bottomnav.dart';
import 'package:firebase_core/firebase_core.dart'; // ovo je za Firebase



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home:  UploadEvent(), // dodali smo const
    );
  }
}
