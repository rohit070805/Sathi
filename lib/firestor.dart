import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firebase_firestor{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({required String email,required String username}) async{
    await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email':email,
      'username':username,
      'followers':[],
      'following':[]
    });
    return true;
  }

}