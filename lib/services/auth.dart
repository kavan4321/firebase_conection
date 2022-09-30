import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_conection/models/user.dart';
import 'package:firebase_conection/services/database.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//create user obj based on firebase user

  MyUsers? _userFromFirebaseUser(User? user) {
    return user != null ? MyUsers(uid: user.uid) : null;
  }

//auth change user stream
  Stream<MyUsers?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth
          .signInAnonymously(); // AuthResult change to UserCredential
      User? user = result.user; //FirebaseUser to User
      return _userFromFirebaseUser(user!);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //sign in with email & pass

  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //register with enail &pass

  Future registerEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

//create a new doc for the user with the uid

      await DatabaseService(uid: user!.uid)
          .updateUserData('0', 'new member', 100);

      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
