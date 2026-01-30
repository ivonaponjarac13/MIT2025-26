import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> _bookingsCache = [];

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Morate biti prijavljeni da vidite kupljene karte."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Moje karte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20)),
        backgroundColor: const Color(0xff6351ec),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user_bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Ako imamo podatke, čuvamo ih u cache
          if (snapshot.hasData) {
            _bookingsCache = snapshot.data!.docs;
          }

          // Koristimo cache da ne nestaje lista
          final bookings = _bookingsCache;

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'Nema kupljenih karata',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['eventName'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(data['date'] ?? ''),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(data['time'] ?? ''),
                          const SizedBox(width: 16),
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['location'] ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${data['tickets']}x ulaznica | Ukupno: ${data['totalPrice'].toStringAsFixed(2)} €",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff6351ec),
                        ),
                      ),
                    ],
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
