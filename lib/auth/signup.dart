import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firestoredb/user_repository.dart';
import '../theming/icons.dart';

// Define a custom Form widget.
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? emailAddress;
  String? password;
  final FirestoreService _firestoreService = FirestoreService(); // Instance of FirestoreService
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    // Email
                    onChanged: (value) => emailAddress = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    // Password
                    obscureText: true,
                    obscuringCharacter: '*',
                    onChanged: (value) => password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                    },
                  ),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailAddress!,
                          password: password!,
                        );
                        await _firestoreService.createUserProfile(credential.user!);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "The password provided is too weak.")));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'The account already exists for that email.')));
                        }
                      }
                    }
                  },
                  child: const Text("Sign Up"),
                )
              ],
            ),
          ),
        ),
        ButtonBar(
          children: [
            ElevatedButton(
                onPressed: () => {
                      // handle auth with google
                    },
                child: withgoogleICON)
          ],
        )
      ],
    );
  }
}
