import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feedback-support.dart';
import 'dashboard.dart';
import 'settings.dart';
import '../firestoredb/user_repository.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int index = 1;
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = await _firestoreService.getUserData(userId);
    setState(() {}); // Rebuild the widget with the fetched data
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      FeedbackSupport(),
      userData != null ? Dashboard(userData: userData) : CircularProgressIndicator(),
      userData != null ? Settings(userData: userData) : CircularProgressIndicator(),
    ];

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int newIndex) => setState(() => index = newIndex),
          selectedIndex: index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.feedback),
              label: "Feedback",
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
