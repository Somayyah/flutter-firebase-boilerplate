import 'package:flutter/material.dart';
import '../theming/icons.dart';
import '../auth/signin.dart';
import '../auth/signup.dart';

class SignInUp extends StatelessWidget {
  const SignInUp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: height * 0.25,
                leadingWidth: 100,
                elevation: 0,
                title: Icon(Icons.access_alarm, size: 50),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: loginIcon,
                      text: "Sign In",
                    ),
                    Tab(
                      icon: registerationIcon,
                      text: "Sign Up",
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [SignIn(), SignUp()],
              ),
            )));
  }
}
