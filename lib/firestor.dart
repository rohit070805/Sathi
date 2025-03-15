import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sathi/userModal.dart';
import 'package:uuid/uuid.dart';

class Firebase_firestor{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({required String email,required String username,required String aadharNumber,required String dob}) async{
    await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email':email,
      'username':username,
      'aadharNumber':aadharNumber,
      'dob':dob,
      'followers':[],
      'following':[]
    });
    return true;
  }
  Future<Usermodel> getUser()async{
    try{
      final user = await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).get();
      final snapuser = user.data()!;
      return Usermodel(snapuser['username'], snapuser['email'],snapuser['aadharNumber'],snapuser['dob'],snapuser['followers'], snapuser['following']);
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


  Future<void> followUser(String currentUserId, String userIdToFollow) async {
    try {
       await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(userIdToFollow)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdToFollow)
          .collection('followers')
          .doc(currentUserId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error following user: $e");
    }

  }
  Future<void> unfollowUser(String currentUserId, String userIdToUnfollow) async {
    try {
        await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(userIdToUnfollow)
          .delete();

       await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdToUnfollow)
          .collection('followers')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  Future<List<Map<String, String>>> getFollowersWithNames(String currentUserId) async {
    try {
      // Get the list of follower userIds
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId) // Current user's document
          .collection('followers')
          .get();

      List<Map<String, String>> followers = [];

      for (var followerDoc in followersSnapshot.docs) {
        String followerUserId = followerDoc.id;

        // Fetch the name of the follower userId from the 'users' collection
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(followerUserId)
            .get();

        String followerName = userSnapshot['username']; // Assuming 'name' field exists
        followers.add({
          'uid': followerUserId,
          'username': followerName,
        });
      }

      return followers;
    } catch (e) {
      print("Error fetching followers with names: $e");
      return [];
    }
  }

  Future<List<Map<String, String>>> getFollowingsWithNames(String currentUserId) async {
    try {
      // Get the list of userIds the current user is following
      QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId) // Current user's document
          .collection('following')
          .get();

      List<Map<String, String>> followings = [];

      for (var followingDoc in followingSnapshot.docs) {
        String followingUserId = followingDoc.id;

        // Fetch the name of the following userId from the 'users' collection
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(followingUserId)
            .get();

        String followingName = userSnapshot['username']; // Assuming 'name' field exists
        followings.add({
          'uid': followingUserId,
          'username': followingName,
        });
      }

      return followings;
    } catch (e) {
      print("Error fetching followings with names: $e");
      return [];
    }
  }
  Future<int> getFollowersCount(String currentUserId) async {
    try {
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('followers')
          .get();

      return followersSnapshot.docs.length; // Count of followers
    } catch (e) {
      print('Error fetching followers count: $e');
    return 0;
    }
  }

  Future<bool> isFollowing(String currentUserId,String targetUserId)async{
    final followingRef = _firebaseFirestore.collection('users').doc(currentUserId).collection('following').doc(targetUserId);
    return (await followingRef.get()).exists;
  }

  Future<int> getFollowingCount(String currentUserId) async {
    try {
      QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .get();

      return followingSnapshot.docs.length; // Count of following
    } catch (e) {
      print('Error fetching following count: $e');
      return 0;
    }
  }
  Future<List<String>> getFollowingList(String currentUserId) async {
    QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId) // Current user's document
        .collection('following')
        .get();
    List<String> followings = [];

    for (var followingDoc in followingSnapshot.docs) {
      String followingUserId = followingDoc.id;
      followings.add(followingUserId);
    }


      return followings;
  }
  Future<void> updateChatList(String currentUserId,String currentUserName, String otherUserId, String otherUserName) async {
    DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
    DocumentReference otherUserRef = FirebaseFirestore.instance.collection('users').doc(otherUserId);

    // Add the other user to the current user's chat list
    await currentUserRef.collection('chats').doc(otherUserId).set({
      'uid': otherUserId,
      'name': otherUserName,
      'lastMessage': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Add the current user to the other user's chat list
    await otherUserRef.collection('chats').doc(currentUserId).set({
      'uid': currentUserId,
      'name': currentUserName, // You can replace it with your user's name
      'lastMessage': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  // Future<List<Map<String, dynamic>>> getPostsFromFollowing(String currentUserId) async {
  //   // Resolve the Future to get the actual list
  //   final followingList = await getFollowingList(currentUserId);
  //
  //   // Use the resolved list in the whereIn clause
  //   final postsSnapshot = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .where('uid', whereIn: followingList) // Pass the resolved list
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //
  //   return postsSnapshot.docs.map((doc) => doc.data()).toList();
  // }
}