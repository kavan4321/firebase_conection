import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_conection/models/brew.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});
  DatabaseService.withoutUID() : uid = "";
  //collection services
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strenght) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strenght,
    });
  }
  //brew list from snapshot

  List _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          name: doc.get('name') ?? '',
          sugars: doc.get('sugars') ?? '0',
          strength: doc.get('strength') ?? 0);
    }).toList();
  }

//get brews stream
  Stream<List> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}
