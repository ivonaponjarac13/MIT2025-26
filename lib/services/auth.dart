import 'package:eventify/pages/bottomnav.dart';
import 'package:eventify/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Dohvati trenutnog korisnika
  Future<User?> getCurrentUser() async {
    return await auth.currentUser;
  }

  // Prijava preko Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential result = await auth.signInWithCredential(credential);
    User? userDetails = result.user;

    if (userDetails != null) {
      Map<String, dynamic> userInfoMap = {
        "Name": userDetails.displayName,
        "Image": userDetails.photoURL,
        "email": userDetails.email,
        "Id": userDetails.uid,
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

    return userDetails;
  }

  // **Odjava**
  Future<void> signOut(BuildContext context) async {
    await googleSignIn.signOut(); // odjava sa Google
    await auth.signOut();          // odjava sa Firebase

    // Vrati korisnika na stranicu za prijavu (SignUp)
    Navigator.pushReplacementNamed(context, '/signup');
  }
}
