import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sathi/userModal.dart';
import 'package:uuid/uuid.dart';

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
  Future<Usermodel> getUser()async{
    try{
      final user = await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).get();
      final snapuser = user.data()!;
      return Usermodel(snapuser['username'], snapuser['email'], snapuser['followers'], snapuser['following']);
    }on FirebaseException catch(e){
      throw e.message.toString();
    }
  }
  Future<bool> CreatePost({
    required String starting,
    required String destination,
    required DateTime startdate,
    required DateTime endDate,
    required int members
})async{
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'Starting':starting,
      'Destination':destination,
      'StartDate':startdate,
      'EndDate':endDate,
      'members':members,
      'username':user.username,
      'postId':uid,
      'time':data,
      'uid':_auth.currentUser!.uid
    });
    return true;
  }


}
