import 'package:eventify/pages/bottomnav.dart';
import 'package:eventify/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "Name": userDetails!.displayName,
        "Image": userDetails?.photoURL,
        "email": userDetails?.email,
        "Id": userDetails?.uid,
      };

      await DatabaseMethods().addUserDetail(userInfoMap, userDetails.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Uspješna prijava kao ${userDetails.displayName}",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }
  }
}
