import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firestor.dart';
import 'package:sathi/followingsList.dart';
import 'package:sathi/userChat.dart';
class expenditurePage extends StatefulWidget {
  const expenditurePage({super.key});

  @override
  State<expenditurePage> createState() => _expenditurePageState();
}

class _expenditurePageState extends State<expenditurePage> {
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
            title: const Text("Posts from Following",style: TextStyle(color: Colors.white,fontSize: 30),),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 5,right: 5),
              child: FutureBuilder(
                    future: Firebase_firestor().getFollowingList(_auth.currentUser!.uid),
                    builder: (context,followingSnapshot) {
                      if (followingSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: Colors.black,));
                      } else if (followingSnapshot.hasError) {
                        return Center(child: Text('Error: ${followingSnapshot.error}'));
                      } else if (!followingSnapshot.hasData || followingSnapshot.data!.isEmpty) {
                        return Center(child: Text('No posts available.'));
                      }

                      final followings = followingSnapshot.data!;

                    return FutureBuilder(
                      future: fetchPosts(followings),
                      builder: (context,postsSnapshot){
                        if (!postsSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator(color: Colors.black,));
                        }
                        if(postsSnapshot.data!.isEmpty){
                          return Center(
                            child: Text("No posts from the users you follow."),
                          );
                        }

                        final post = postsSnapshot.data!;

                        if (post.isEmpty) {
                          return Center(
                            child: Text("No posts from the users you follow."),
                          );
                        }

                        return ListView.builder(
                    itemCount: postsSnapshot.data == null ? 0 : post.length,
                    itemBuilder: (context, index) {
                    final data = post[index];

                    return InkWell(
                    onTap: () {
                    showDialog(context: context,
                    builder: (context) => CustomDialogWidget(data));
                    },
                    child: Hero(
                    tag: data['postId'],
                    child: Container(
                    height: 270,
                    child: Card(
                    color: Colors.white,
                    elevation: 4,

                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround,
                    children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround,
                    children: [
                    Row(

                    children: [
                    CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                    radius: 34,
                    backgroundImage: AssetImage(
                    'assets/images/person.png'),
                    backgroundColor: Colors.grey
                        .shade200,
                    )
                    ),
                    SizedBox(width: 10,),
                    Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                    Text(data['username'],
                    style: TextStyle(
                    fontSize: 18),),
                    _auth.currentUser!.uid !=
                    data['uid'].toString() ?
                    FutureBuilder(
                    future: followButton(
                    _auth.currentUser!.uid,
                    data['uid'].toString()),
                    builder: (context,
                    snapshot) {
                    if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                    return CircularProgressIndicator(
                    color: Colors.black,);
                    }
                    else
                    if (snapshot.hasError) {
                    return Text(
                    'Error!!',
                    style: TextStyle(
                    color: Colors
                        .red),);
                    }
                    else
                    if (snapshot.hasData) {
                    return snapshot.data!;
                    }
                    else {
                    return Text(
                    'No Data Available');
                    }
                    }) :
                    Text('Your Post',
                    style: TextStyle(
                    fontSize: 14,
                    color: appColor))


                    ],
                    )
                    ],
                    ),

                    Row(
                    children: [
                    Icon(Icons.people),
                    SizedBox(width: 10,),
                    Text(data['members'].toString(),
                    style: TextStyle(fontSize: 18),)
                    ],
                    ),

                    ],
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly,
                    children: [
                    Text(data['Starting'].length <= 5
                    ? data['Starting']
                        : data['Starting'].substring(0, 5) +
                    '..',
                    style: TextStyle(fontSize: 18),),
                    Icon(Icons.location_on_outlined,
                    color: appColor,),
                    Text(data['Destination'].length <= 5
                    ? data['Destination']
                        : data['Destination'].substring(
                    0, 5) + '..',
                    style: TextStyle(fontSize: 18),)

                    ],
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly,
                    children: [
                    Text(formatDate(
                    data['StartDate'].toDate(),
                    [yyyy, '-', mm, '-', dd]),
                    style: TextStyle(fontSize: 18),),
                    Icon(Icons.calendar_month_sharp,
                    color: appColor,),
                    Text(formatDate(
                    data['EndDate'].toDate(),
                    [yyyy, '-', mm, '-', dd]),
                    style: TextStyle(fontSize: 18),)
                    ],
                    ),
                    Divider(thickness: 1,),
                    InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) =>
                    Userchat(currentUserId: _auth.currentUser!.uid, otherUserId: data['uid'], otherUserName: data['username'])));
                    },
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                    Text("Procced to Chat",
                    style: TextStyle(fontSize: 18,
                    color: appColor),),

                    ],
                    ),
                    ),
                    SizedBox(width: 5,)

                    ],
                    ),
                    ),
                    ),
                    ),
                    );
                    },

                    );
                    }
                    );
                  }
                  )
                
            ),
          )

      );

  }
  Future<Widget> followButton(String currentUserId,String targetUserId)async{
    return await Firebase_firestor().isFollowing(currentUserId, targetUserId)==true?
    InkWell(
      onTap: ()async{
        await Firebase_firestor().unfollowUser(currentUserId, targetUserId);
        setState(() {
          Fluttertoast.showToast(msg: "Unfollowed Successfully");
        });

      },
      child: Text("Following! Unfollow?",style: TextStyle(fontSize: 14,color: appColor),),
    ):
    InkWell(
      onTap: ()async{
        await Firebase_firestor().followUser(currentUserId, targetUserId);
        setState(() {


          Fluttertoast.showToast(msg: "Followed Successfully");
        });
      },
      child: Text("Follow",style: TextStyle(fontSize: 14,color: appColor),),
    );
  }
  Widget CustomDialogWidget(Map<String,dynamic> data){
    var member = data['members'].toString();
    return Dialog(
      child: Hero(
        tag: data['postId'],
        child: Container(
          height: 270,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(

                    children: [
                      CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey ,
                          child: CircleAvatar(
                            radius: 34,
                            backgroundImage: AssetImage('assets/images/person.png'),
                            backgroundColor: Colors.grey.shade200,
                          )
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['username'],style: TextStyle(fontSize: 18),),
                          _auth.currentUser!.uid != data['uid'].toString()?
                          FutureBuilder(
                              future: followButton(
                                  _auth.currentUser!.uid,
                                  data['uid'].toString()),
                              builder: (context, snapshot) {
                                if (snapshot
                                    .connectionState ==
                                    ConnectionState
                                        .waiting) {
                                  return CircularProgressIndicator(
                                    color: Colors.black,);
                                }
                                else
                                if (snapshot.hasError) {
                                  return Text(
                                    'Error!!',style: TextStyle(color: Colors.red),);
                                }
                                else if (snapshot.hasData) {
                                  return snapshot.data!;
                                }
                                else {
                                  return Text(
                                      'No Data Available');
                                }
                              }):
                          Text('Your Post',style: TextStyle(fontSize: 14,color: appColor))
                        ],
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 10,),
                      Text(data['members'].toString(),style: TextStyle(fontSize: 18),)
                    ],
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(data['Starting'],style: TextStyle(fontSize: 18),),
                  Icon(Icons.location_on_outlined,color: appColor,),
                  Text(data['Destination'],style: TextStyle(fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(formatDate(data['StartDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 18),),
                  Icon(Icons.calendar_month_sharp,color: appColor,),
                  Text(formatDate(data['EndDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 18),)
                ],
              ),
              Divider(thickness: 1,),
              InkWell(
                splashColor: Colors.transparent,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Userchat(currentUserId: _auth.currentUser!.uid, otherUserId: data['uid'], otherUserName: data['username'])));

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Procced to Chat",style: TextStyle(fontSize: 18,color: appColor),),

                  ],
                ),
              ),
              SizedBox(width: 5,)

            ],
          ),
        ),
      ),
    );

  }

  Future<List<String>> followingList(String userId)async{
    return await Firebase_firestor().getFollowingList(userId);
  }

  Future<List<Map<String, dynamic>>> fetchPosts(List<String> followingList) async {
    if (followingList.isEmpty) {
      return [];
    }

    // Fetch posts from Firestore where uid is in the following list
    QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', whereIn: followingList)
        .orderBy('time', descending: true) // Order posts by time
        .get();

    return postsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
 
}
