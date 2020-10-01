import 'package:flutter/material.dart';

import 'widgets/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      home: Profile(),
      theme: ThemeData(
        primaryColor: Colors.green[300],
      ),
    );
  }
}
