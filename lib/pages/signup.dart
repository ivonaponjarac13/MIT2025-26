
import 'package:eventify/pages/admin_page';
import 'package:eventify/services/auth.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  bool showAdminLogin = false; // da prikazujemo admin formu
  TextEditingController adminUserController = TextEditingController();
  TextEditingController adminPassController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // ispod ekrana
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _toggleAdminLogin() {
    setState(() {
      showAdminLogin = !showAdminLogin;
      if (showAdminLogin) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _loginAdmin() {
    String username = adminUserController.text.trim();
    String password = adminPassController.text.trim();

    if (username == "admin" && password == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Pogrešno korisničko ime ili šifra",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    adminUserController.dispose();
    adminPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/onboarding.png"),
              const SizedBox(height: 10.0),
              const Text(
                "Otvori vrata nezaboravnim događajima uz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Eventify",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff6351ec),
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Otkij, rezerviši i uživaj u događajima u samo nekoliko klikova.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 12.0),
              ),
              const SizedBox(height: 20.0),

              // Google login
              GestureDetector(
                onTap: () {
                  AuthMethods().signInWithGoogle(context);
                },
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff6351ec),
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
                      const SizedBox(width: 20.0),
                      const Text(
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
              ),

              const SizedBox(height: 15),

              // Dugme za admin login
              GestureDetector(
                onTap: _toggleAdminLogin,
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xff6351ec),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Prijava Admina",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Animirana admin forma – pojavljuje se IZNAD ostatka, a ne prekriva dugme
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: showAdminLogin
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xfff1f3ff),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: adminUserController,
                              decoration: const InputDecoration(
                                labelText: "Korisničko ime",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: adminPassController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Šifra",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _loginAdmin,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff6351ec), Color(0xff9675ff)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Prijavi se",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
