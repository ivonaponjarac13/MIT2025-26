import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  final String? image;
  final String? name;
  final String? location;
  final String? date;
  final String? time; // satnica događaja
  final String? detail;
  final String? price; // cijena JEDNE karte iz Firebase-a

  const DetailPage({
    super.key,
    this.image,
    this.name,
    this.location,
    this.date,
    this.detail,
    this.price,
    this.time,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int ticket = 1;

  double get pricePerTicket {
    return double.tryParse(widget.price ?? "0") ?? 0;
  }

  double get totalPrice {
    return pricePerTicket * ticket;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveBookingToFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('user_bookings').add({
      'userId': user.uid,
      'eventName': widget.name ?? '',
      'date': widget.date ?? '',
      'time': widget.time ?? '',
      'location': widget.location ?? '',
      'tickets': ticket,
      'totalPrice': totalPrice,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void openFakePayment() {
    // Kontroleri za textfield-e
    final cardController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Plaćanje karticom"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cardController,
              decoration: const InputDecoration(labelText: "Broj kartice"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: expiryController,
              decoration: const InputDecoration(labelText: "Datum isteka"),
            ),
            TextField(
              controller: cvvController,
              decoration: const InputDecoration(labelText: "CVV"),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Provjera da li su svi podaci uneseni
              if (cardController.text.isEmpty ||
                  expiryController.text.isEmpty ||
                  cvvController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Molimo popunite sva polja kartice!"),
                    backgroundColor: Colors.red,
                  ),
                );
                return; // izlaz iz funkcije, ne zatvara dialog
              }

              // Ako su podaci uneseni, zatvori dialog
              Navigator.pop(context);

              // Spremi kupovinu u Firebase
              await saveBookingToFirebase();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Plaćanje uspješno i karta je spremljena"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Plati"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌆 Slika sa overlay-om za naziv, datum i lokaciju
            Stack(
              children: [
                Image.asset(
                  widget.image ?? "images/koncert.jpg",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Naziv događaja
                      Text(
                        widget.name ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black54,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Datum i lokacija
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.date ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.location ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.detail ?? "",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Ulaznice:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: ticket > 1
                        ? () {
                            setState(() {
                              ticket--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    ticket.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ticket++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 💰 UKUPNA CIJENA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ukupno: ${totalPrice.toStringAsFixed(2)} €",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6351ec),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      final user = _auth.currentUser;
                      if (user == null) {
                        // Ako nije prijavljen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Morate biti prijavljeni da biste kupili kartu!",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Ako je prijavljen, otvori plaćanje
                        openFakePayment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6351ec),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Plati",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
