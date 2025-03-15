import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firestor.dart';
class followersList extends StatefulWidget {
  const followersList({super.key});

  @override
  State<followersList> createState() => _followersListState();
}

class _followersListState extends State<followersList> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: const Text("F o l l o w e r s",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: SafeArea(
          child: Padding(padding:
      EdgeInsets.all(10),
          child:FutureBuilder<List<Map<String, String>>>(
              future: Firebase_firestor().getFollowersWithNames(_auth.currentUser!.uid), // Get followers with names
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No followers.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var follower = snapshot.data![index];
                      return InkWell(
                        onLongPress: (){
                          showDialog(context: context,
                              builder: (context)=>
                                  AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text("Remove Follower",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    ),
                                    content: Text("Friend will be Removed"),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("Cancel",style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),),
                                      ElevatedButton(onPressed: ()async{
                                        try{
                                          await  Firebase_firestor().unfollowUser(follower['uid'].toString(),_auth.currentUser!.uid);
                                          Navigator.pop(context);
                                          setState(() {


                                            Fluttertoast.showToast(msg: "Follower Removed", toastLength: Toast.LENGTH_SHORT);
                                          });
                                        }catch(e){
                                          Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT);

                                        }
                                      }, child: Text("Remove",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
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
                          title: Text(follower['username'] ?? 'Unknown'), // Display follower's name
                          subtitle: Text("Hold to Remove"),
                           ),
                      );
                    },
                  );
                }
                },
              )

          )

      ),
    );
  }
}
