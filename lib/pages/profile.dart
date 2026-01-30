
import 'package:eventify/pages/signup.dart';
import 'package:eventify/services/auth.dart';
import 'package:eventify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  void refreshUser() {
    setState(() {
      user = _auth.currentUser;
    });
  }

  void _showEditNameDialog() {
    if (user == null) return;
    TextEditingController nameController =
        TextEditingController(text: user!.displayName ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Promeni ime"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Unesite novo ime"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () async {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await user!.updateDisplayName(newName);
                await user!.reload();
                refreshUser();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Ime uspešno promenjeno!")),
                );
              }
            },
            child: const Text("Sačuvaj"),
          ),
        ],
      ),
    );
  }

  void _showMyEvents() {
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyEventsPage(userId: user!.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = user?.displayName ?? "Korisnik";
    final userEmail = user?.email ?? "";

    return Scaffold(
      backgroundColor: const Color(0xfff1f3ff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Moj profil",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xff6351ec),
                      child: Text(
                        userName.isNotEmpty ? userName[0] : "K",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user != null)
                            Text(
                              userEmail,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // OPCIJE
              if (user != null) ...[
                _optionCard("Uredi profil", Icons.edit,
                    onTap: _showEditNameDialog),
                const SizedBox(height: 15),
                _optionCard("Moji događaji", Icons.event,
                    onTap: _showMyEvents),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      user = null;
                    });
                    await AuthMethods().signOut(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xff6351ec), Color(0xffa183ff)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Odjavi se",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xff6351ec), Color(0xffa183ff)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Prijavi se",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionCard(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff6351ec)),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}

/// Stranica Moji događaji (premium UI)
class MyEventsPage extends StatelessWidget {
  final String userId;
  const MyEventsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moji događaji"),
        backgroundColor: const Color(0xff6351ec),
      ),
      body: StreamBuilder(
        stream: DatabaseMethods().getUserBookedEvents(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("Još nisi kupio nijednu kartu."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Image.asset(
                    data["ImageURL"] ?? "images/booking.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    data["eventName"] ?? "Nepoznat događaj",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    data["date"] ?? "",
                  ),
                  trailing: Text(
                    "${data["totalPrice"] ?? "0"}€",
                    style: const TextStyle(
                        color: Color(0xff6351ec),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
