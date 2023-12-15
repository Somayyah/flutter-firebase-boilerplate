import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Dashboard({Key? key, this.userData}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

// Updated static list of applications
class _DashboardState extends State<Dashboard> {
  Set<String> selectedApps = Set<String>();

  @override
  Widget build(BuildContext context) {

    return Container(

    );
  }
}
