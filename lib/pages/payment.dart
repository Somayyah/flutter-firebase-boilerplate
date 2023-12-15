import 'package:flutter/material.dart';
import 'mainscreen.dart';
class Payment extends StatelessWidget {
  const Payment({super.key});

  void doNothing() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))
        },
        child: Text("Click to go to dashboard"),
      ),
    );
  }
}
