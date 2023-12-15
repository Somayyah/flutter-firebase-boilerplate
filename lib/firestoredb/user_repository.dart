import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(User user) async {
    String username = extractUsernameFromEmail(user.email);
    var uuid = Uuid();
    String randomId = uuid.v4(); // Generates a random UUID

    await _firestore.collection('users').doc(user.uid).set({
      'username': username,
      'randomId': randomId,
    });
  }

  String extractUsernameFromEmail(String? email) {
    return email?.split('@')?.first ?? '';
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null; // Return null in case of any error
    }
  }

  Future<void> addUserAppName(String userId, String appName) async {
    DocumentReference userDoc = _firestore.collection('users').doc(userId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      List<dynamic> appNames = snapshot.get('appNames');
      if (!appNames.contains(appName)) {
        appNames.add(appName);
        transaction.update(userDoc, {'appNames': appNames});
      }
    });
  }
}
