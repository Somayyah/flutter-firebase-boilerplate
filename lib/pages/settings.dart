import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatelessWidget {
  final Map<String, dynamic>? userData;

  // Constructor that accepts userData
  const Settings({Key? key, this.userData}) : super(key: key);

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    String userName = userData?['username'] ?? 'User';

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $userName'), // Display the user's name
            const SizedBox(height: 20),
            FloatingActionButton(
              child: const Text("Log out"),
              onPressed: () => signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
