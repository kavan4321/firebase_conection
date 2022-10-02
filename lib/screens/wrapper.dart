import 'package:firebase_conection/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_conection/screens/home/home.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUsers?>(context);

    //returen either home or authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return Scaffold(
        body: Home(),
      );
    }
  }
}
