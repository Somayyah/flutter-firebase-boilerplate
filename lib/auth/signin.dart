import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theming/icons.dart';

// Define a custom Form widget.
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() {
    return SignInState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String? emailAddress;
  String? password;

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
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailAddress!,
                          password: password!,
                        );
                      } on FirebaseAuthException catch (e) {
                        print("Exception new: " + e.code);
                        if (e.code == 'invalid-credential') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wrong password or user doesn\'t exist.'))
                          );
                        } else if (e.code == 'too-many-requests') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Too many failed authentication requests, reset your password'))
                          );
                        }
                      }
                    }
                  },
                  child: Text("Sign In"),
                ),
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
                child: withgoogleICON),
            ElevatedButton(
                onPressed: () => {
                  // handle auth with facebook
                },
                child: withgoogleICON),
          ],
        )
      ],
    );
  }
}

