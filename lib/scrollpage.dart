import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'userChat.dart';
import 'package:sathi/firestor.dart';
import 'profilepage.dart';
class scrollpage extends StatefulWidget {
  const scrollpage({super.key});

  @override
  State<scrollpage> createState() => _scrollpageState();
}

class _scrollpageState extends State<scrollpage> {
  DateTime now = DateTime.now();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['username'] ?? 'Unknown';
  }


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
          title: const Text("E x p l o r e",style: TextStyle(color: Colors.white,fontSize: 30),),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: StreamBuilder(
              stream: _firebaseFirestore.collection('posts').orderBy('time',descending: true).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(color: Colors.black,),);
                }
                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: snapshot.data == null?0:posts.length,
                  itemBuilder: (context,index){
                    final post = posts[index];
                    final data = post.data() as Map<String,dynamic>;

                    return InkWell(
                      onTap: (){
                        showDialog(context: context,
                            builder: (context)=>CustomDialogWidget(data));
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
                                          children:[
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
                                    Text(data['Starting'].length<=5?data['Starting']:data['Starting'].substring(0,5)+'..',style: TextStyle(fontSize: 18),),
                                    Icon(Icons.location_on_outlined,color: appColor,),
                                    Text(data['Destination'].length<=5?data['Destination']:data['Destination'].substring(0,5)+'..',style: TextStyle(fontSize: 18),)

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
                                _auth.currentUser!.uid != data['uid'].toString()?
                                 InkWell(
                              splashColor: Colors.transparent,
                              onTap: ()async{
                                String currentUserName = await getCurrentUserName(_auth.currentUser!.uid);
                                Firebase_firestor().updateChatList(_auth.currentUser!.uid.toString(),currentUserName, data['uid'], data['username']);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Userchat(currentUserId: _auth.currentUser!.uid.toString(), otherUserId: data['uid'], otherUserName: data['username'])));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Procced to Chat",style: TextStyle(fontSize: 18,color: appColor),),
                                ],
                              ),
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Your Post",style: TextStyle(fontSize: 18,color: appColor),),


                              ],
                            ),
                                SizedBox(width: 5,),
                            ]
                          ),
                        ),
                      ),)
                    );
                  },

                );
              },
              
            ),
          ),
        )

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
              _auth.currentUser!.uid != data['uid'].toString()?
              InkWell(
                splashColor: Colors.transparent,
                onTap: ()async{
                  String currentUserName = await getCurrentUserName(_auth.currentUser!.uid);
                  Firebase_firestor().updateChatList(_auth.currentUser!.uid.toString(),currentUserName, data['uid'], data['username']);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Userchat(currentUserId: _auth.currentUser!.uid.toString(), otherUserId: data['uid'], otherUserName: data['username'])));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Procced to Chat",style: TextStyle(fontSize: 18,color: appColor),),

                  ],
                ),
              ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Post",style: TextStyle(fontSize: 18,color: appColor),),

                ],
              ),

              SizedBox(width: 5,)

            ],
          ),
        ),
      ),
    );

  }
  Future<Widget> followButton(String currentUserId,String targetUserId)async{
    return await Firebase_firestor().isFollowing(currentUserId, targetUserId)==true?
    InkWell(
      onTap: ()async{
        await Firebase_firestor().unfollowUser(currentUserId, targetUserId);
        Navigator.pop(context);
        setState(() {
          Fluttertoast.showToast(msg: "Unfollowed Successfully");
        });

      },
      child: Text("Following! Unfollow?",style: TextStyle(fontSize: 14,color: appColor),),
    ):
    InkWell(
      onTap: ()async{
        await Firebase_firestor().followUser(currentUserId, targetUserId);
        Navigator.pop(context);
        setState(() {


          Fluttertoast.showToast(msg: "Followed Successfully");
        });
      },
      child: Text("Follow",style: TextStyle(fontSize: 14,color: appColor),),
    );
  }

}
