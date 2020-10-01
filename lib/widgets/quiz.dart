import 'dart:convert';

import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var _questions;
  int _questionIndex = 0;
  int _totalScore = 0;
  final Map<int, String> _answers = {};

  Future<bool> _loadQuestions(BuildContext context) async {
    String _res = await DefaultAssetBundle.of(context)
        .loadString('assets/questions.json');
    var _myData = await json.decode(_res);
    setState(() {
      _questions = _myData["questions"];
    });
    return true;
  }

  void _nextQuestion() {
    if (_questionIndex == _questions.length - 1) {
      _totalScore = _calculateScore();
      Navigator.pop(context, _totalScore);
      return;
    }
    setState(() {
      _questionIndex += 1;
    });
  }

  int _calculateScore() {
    int _currScore = 0;
    _answers.forEach((key, value) {
      if (_questions[key]['Correct'] == value) {
        _currScore++;
      }
    });
    return _currScore;
  }

  void _prevQuestion() {
    setState(() {
      _questionIndex -= 1;
    });
  }

  void _selectAnswer(value) {
    setState(() {
      _answers[_questionIndex] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );

    return WillPopScope(
      onWillPop: () async {
        if (_questionIndex > 0) {
          setState(() {
            _questionIndex -= 1;
          });
          return false;
        } else {
          return showDialog<bool>(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text('Do you want to quit the quiz?'),
                title: const Text('Warning'),
                actions: <Widget>[
                  RaisedButton(
                      child: const Text(
                        'Yes',
                        style: textStyle,
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                  RaisedButton(
                      child: const Text(
                        'No',
                        style: textStyle,
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quiz',
            style: textStyle,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _loadQuestions(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_questionIndex + 1}.',
                            style: const TextStyle(fontSize: 22),
                          ),
                          Expanded(
                            child: Question(
                                _questions[_questionIndex]['question']),
                          ),
                        ],
                      ),
                    ),
                    ...(_questions[_questionIndex]['answers']).map((answer) {
                      return Answer(
                          answer, _answers[_questionIndex], _selectAnswer);
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_questionIndex > 0)
                          RaisedButton(
                            onPressed: _prevQuestion,
                            color: Theme.of(context).primaryColor,
                            child: const Text(
                              'Prev',
                              style: textStyle,
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (_answers[_questionIndex] != null)
                          RaisedButton(
                            onPressed: _nextQuestion,
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              _questionIndex != _questions.length - 1
                                  ? 'Next'
                                  : 'End',
                              style: textStyle,
                            ),
                          ),
                      ],
                    )
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
