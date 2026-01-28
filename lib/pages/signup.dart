import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity, // da kolona zauzme celu širinu ekrana
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // centriraj horizontalno
          children: [
            Image.asset("images/onboarding.png"),
            SizedBox(height: 10.0),
            Text(
              "Otvori vrata nezaboravnim događajima uz",
              textAlign:
                  TextAlign.center, // centriraj tekst unutar Text widget-a
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Eventify",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Otkij, rezerviši i uživaj u događajima u samo nekoliko klikova.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
            SizedBox(height: 20.0),
            Container(
              height:60,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              margin: EdgeInsets.only(left:20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xff6351ec),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/google.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    "Nastavi sa Google nalogom",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
