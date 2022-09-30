import 'package:firebase_conection/screens/home/brew_list.dart';
import 'package:firebase_conection/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_conection/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List>.value(
      value: DatabaseService.withoutUID().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('logout'),
            )
          ],
        ),
        body: const BrewList(),
      ),
    );
  }
}
