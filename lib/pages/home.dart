import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/pages/detail_page.dart';
import 'package:eventify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot> eventStream;
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedCategory = "";
  String searchText = "";

  Map<String, String> categoryImages = {
    "Koncert": "images/koncert.jpg",
    "Sportski događaj": "images/utakmica.jpg",
    "Pozorišna predstava": "images/predstava.jpg",
    "Film": "images/bioskop.jpeg",
  };

  @override
  void initState() {
    super.initState();
    eventStream = DatabaseMethods().getAllEvents();
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void scrollToEvents() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      selectedCategory = "";
      searchText = "";
    });
  }

  Widget allEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: eventStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Greška: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Nema dostupnih događaja."));
        }

        // FILTRIRANJE LOKALNO
        final docs = snapshot.data!.docs.where((ds) {
          final data = ds.data() as Map<String, dynamic>;
          final name = (data["Name"] ?? "").toString().toLowerCase();
          final location = (data["Location"] ?? "").toString().toLowerCase();
          final category = (data["Category"] ?? "").toString();

          final matchesCategory = selectedCategory.isEmpty || category == selectedCategory;
          final matchesSearch = searchText.isEmpty ||
              name.contains(searchText.toLowerCase()) ||
              location.contains(searchText.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

        if (docs.isEmpty) {
          return const Center(child: Text("Nema događaja koji odgovaraju filteru."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final ds = docs[index];
            final data = ds.data() as Map<String, dynamic>;

            final name = data["Name"] ?? "Nepoznat događaj";
            final location = data["Location"] ?? "";
            final price = data["Price"] ?? "0";
            final date = data["Date"] ?? "";
            final category = data["Category"] ?? "";

            String formattedDate = "??";
            try {
              final parsed = DateFormat("dd-MM-yyyy").parse(date);
              formattedDate = DateFormat("d MMM").format(parsed);
            } catch (_) {}

            String eventImage = categoryImages[category] ?? "images/koncert.jpg";

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      name: name,
                      location: location,
                      date: date,
                      detail: data["Details"],
                      price: price,
                      image: eventImage,
                      time: data["Time"],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 0.0, left: 0.0),
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            eventImage,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              formattedDate,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "$price€",
                          style: const TextStyle(
                            color: Color(0xff6351ec),
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      Flexible(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _categoryCard(String image, String displayName) {
    final isSelected = selectedCategory == displayName;
    return GestureDetector(
      onTap: () => filterByCategory(displayName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff6351ec) : Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, height: 28, width: 28, fit: BoxFit.cover),
                const SizedBox(height: 5),
                Text(
                  displayName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 13.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final userName = user?.displayName ?? "Korisnik";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.only(right: 20, top: 20, left: 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "Srbija",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Zdravo, $userName!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Postoji 10 zanimljivih događaja\nu tvojoj blizini.",
                  style: TextStyle(
                    color: Color(0xff6351ec),
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                // SEARCH BAR
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  padding: const EdgeInsets.only(left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.trim();
                      });
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search_outlined),
                      border: InputBorder.none,
                      hintText: "Pretraži po nazivu ili lokaciji",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // KATEGORIJE
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _categoryCard("images/musicnote.png", "Koncert"),
                      const SizedBox(width: 30),
                      _categoryCard("images/sports.png", "Sportski događaj"),
                      const SizedBox(width: 30),
                      _categoryCard("images/video.png", "Film"),
                      const SizedBox(width: 30),
                      _categoryCard("images/theatre.png", "Pozorišna predstava"),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Predstojeći događaji",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: GestureDetector(
                        onTap: scrollToEvents,
                        child: const Text(
                          "Vidi sve",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                allEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
