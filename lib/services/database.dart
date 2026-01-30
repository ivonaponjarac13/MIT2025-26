import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("event")
        .doc(id)
        .set(userInfoMap);
  }

  Stream<QuerySnapshot> getAllEvents() {
    return FirebaseFirestore.instance
        .collection("event") // naziv kolekcije
        .snapshots();
  }

  Stream<QuerySnapshot> getEventsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('event')
        .where('Category', isEqualTo: category) 
        .snapshots();
  }

   Stream<QuerySnapshot<Map<String, dynamic>>> getUserBookedEvents(String userId) {
    return FirebaseFirestore.instance
        .collection("user_bookings") // ili kako se zove tvoja kolekcija sa kupljenim kartama
        .where("userId", isEqualTo: userId)
        .snapshots();
  }
}