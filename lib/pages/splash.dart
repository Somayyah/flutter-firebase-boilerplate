import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mainscreen.dart';
import 'signin-up.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigateFromSplash();
  }

  navigateFromSplash() async {
    await Future.delayed(const Duration(seconds: 3)); // wait for 3 seconds
    if (mounted) { // Check if the widget is still in the widget tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return MainScreen(); // Navigate to home page if user is logged in
              } else {
                return const SignInUp(); // Navigate to login page if user is not logged in
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Splash Screen"
    );
  }
}
