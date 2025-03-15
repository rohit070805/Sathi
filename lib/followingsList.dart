import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firestor.dart';
class followingList extends StatefulWidget {
  const followingList({super.key});

  @override
  State<followingList> createState() => _followingListState();
}

class _followingListState extends State<followingList> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: const Text("F o l l o w i n g",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<Map<String, String>>>(
            future: Firebase_firestor().getFollowingsWithNames(_auth.currentUser!.uid), // Get followings with names
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('You are not following anyone.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var following = snapshot.data![index];
                    return InkWell(
                      onLongPress: (){
                        showDialog(context: context,
                            builder: (context)=>
                                AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text("Unfollow",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                  ),
                                  content: Text("Friend will be Unfollowed"),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text("Cancel",style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),),
                                    ElevatedButton(onPressed: ()async{
                                      try{
                                        await  Firebase_firestor().unfollowUser(_auth.currentUser!.uid, following['uid'].toString());
                                        Navigator.pop(context);
                                        setState(() {


                                          Fluttertoast.showToast(msg: "Unfollowed", toastLength: Toast.LENGTH_SHORT);
                                        });
                                      }catch(e){
                                        Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT);

                                      }
                                    }, child: Text("Unfollow",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                                  ],
                                ));
                      },
                      child: ListTile(
                        leading:  CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey ,
                            child: CircleAvatar(
                              radius: 29,
                              backgroundImage: AssetImage('assets/images/person.png',),
                              backgroundColor: Colors.grey.shade200,
                            )
                        ),
                        title: Text(following['username'] ?? 'Unknown'), // Display following's name
                        subtitle: Text("Hold to Remove"),
                         ),
                    );
                  },
                );
              }
              },
            ),
      ),
    );
    ;
  }
}
