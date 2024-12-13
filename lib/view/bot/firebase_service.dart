import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user orders from Firestore
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)  // Assuming 'userId' is stored in order
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
