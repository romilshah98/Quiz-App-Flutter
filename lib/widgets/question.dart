import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String _question;

  Question(this._question);

  @override
  Widget build(BuildContext context) {
    return Text(
      _question,
      style: const TextStyle(
        fontSize: 22,
      ),
      // ),
    );
  }
}
