import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './quiz.dart';
import '../models/scoreStorage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  final ScoreStorage _storage = ScoreStorage();
  final _formKey = GlobalKey<FormState>();
  int _score;

  @override
  void initState() {
    super.initState();
    _getData();
    _storage.readScore().then((int value) {
      setState(() {
        _score = value;
      });
    });
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nickNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitted() {
    final String _firstName = _firstNameController.text;
    final String _lastName = _lastNameController.text;
    final String _nickName = _nickNameController.text;
    final int _age = int.parse(_ageController.text);
    _addData(_firstName, _lastName, _nickName, _age);
  }

  void _addData(String fname, String lname, String nickname, int age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('First Name', fname);
    prefs.setString('Last Name', lname);
    prefs.setString('Nick Name', nickname);
    prefs.setInt('Age', age);
  }

  void _getData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _fname = _prefs.getString('First Name') ?? "";
    String _lname = _prefs.getString('Last Name') ?? "";
    String _nickname = _prefs.getString('Nick Name') ?? "";
    int _age = _prefs.getInt('Age') ?? 0;
    setState(() {
      _firstNameController.text = _fname;
      _lastNameController.text = _lname;
      _nickNameController.text = _nickname;
      _ageController.text = _age == 0 ? "" : _age.toString();
    });
  }

  void _takeQuiz() async {
    final int _result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Quiz()));
    if (_result != null) {
      _storage.writeScore(_result);
      setState(() {
        _score = _result;
      });
    }
  }

  TextFormField _createTextFormField(
    String label,
    TextEditingController controller,
  ) {
    return TextFormField(
      validator: (value) {
        value = value.trim();
        if (value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      keyboardType: label == 'Age' ? TextInputType.number : TextInputType.text,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _createTextFormField('First Name', _firstNameController),
                    _createTextFormField('Last Name', _lastNameController),
                    _createTextFormField('Nick Name', _nickNameController),
                    _createTextFormField('Age', _ageController),
                    const SizedBox(
                      height: 5,
                    ),
                    Builder(
                      builder: (context) => RaisedButton(
                        elevation: 5,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _submitted();
                            final snackBar = SnackBar(
                              content: const Text(
                                'Data Saved!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RaisedButton(
                elevation: 5,
                child: const Text(
                  'Take a quiz',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: _takeQuiz,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 5,
              ),
              if (_score != -1 && _score != null)
                Text('Your Last Score: $_score/4',
                    style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
