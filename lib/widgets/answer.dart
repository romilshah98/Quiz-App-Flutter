import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String _answer;
  final String _groupValue;
  final Function _selectOptionHandler;

  Answer(this._answer, this._groupValue, this._selectOptionHandler);

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(
        _answer,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      value: _answer,
      groupValue: _groupValue,
      onChanged: (value) => _selectOptionHandler(value),
    );
  }
}
