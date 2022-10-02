import 'package:firebase_conection/models/user.dart';
import 'package:firebase_conection/services/database.dart';
import 'package:firebase_conection/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_conection/shared/constant.dart';
import 'package:provider/provider.dart';

class SettingFrom extends StatefulWidget {
  const SettingFrom({super.key});

  @override
  State<SettingFrom> createState() => _SettingFromState();
}

class _SettingFromState extends State<SettingFrom> {
  final _fromKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrenght;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUsers?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _fromKey,
              child: Column(
                children: [
                  const Text(
                    'Update Your Brew Setting',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration,
                    initialValue: userData!.name,
                    validator: (val) =>
                        val!.isEmpty ? 'Please Enter a Name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(height: 20.0),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem<String>(
                        value: sugar,
                        child: Text('$sugar sugers'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),

                  const SizedBox(height: 30.0),

                  //slider
                  Slider(
                      value: (_currentStrenght ?? userData.strength).toDouble(),
                      activeColor:
                          Colors.brown[_currentStrenght ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_currentStrenght ?? userData.strength],
                      min: 100,
                      max: 900,
                      divisions: 8,
                      onChanged: (val) =>
                          setState(() => _currentStrenght = val.round())),

                  const SizedBox(height: 20.0),

                  ElevatedButton(
                      onPressed: () async {
                        /*   debugPrint(_currentName);
                        debugPrint(_currentSugars);
                        debugPrint(_currentStrenght.toString());
                       */
                        if (_fromKey.currentState!.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrenght ?? userData.strength,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
