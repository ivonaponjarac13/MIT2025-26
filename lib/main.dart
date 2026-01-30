import 'package:eventify/admin/upload_event.dart';
import 'package:eventify/pages/detail_page.dart';
import 'package:eventify/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'pages/home.dart'; // obavezno uključi fajl gde se nalazi Home widget
import 'pages/bottomnav.dart';
import 'package:firebase_core/firebase_core.dart'; // ovo je za Firebase



void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51SHpUUPSaDyXrLzY8MOONBbgn0GBmE8iQqDkGojenTsQmZuGBBoHYQSjHtSVYLKOurnFOerGNB2HAS4xssKg4B6b00Wk8cI4Yf'; // tvoj Stripe PUBLIC key

  await Stripe.instance.applySettings();

  runApp(const MyApp());
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
      home:  BottomNav(), // dodali smo const
    );
  }
}
