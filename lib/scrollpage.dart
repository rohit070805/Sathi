import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sathi/colors.dart';
import 'userChat.dart';
class scrollpage extends StatefulWidget {
  const scrollpage({super.key});

  @override
  State<scrollpage> createState() => _scrollpageState();
}

class _scrollpageState extends State<scrollpage> {
  DateTime now = DateTime.now();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    return Container(
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
                                    Icon(Icons.account_circle_rounded,color: Colors.grey,size: 80,),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data['username'],style: TextStyle(fontSize: 18),),
                                        InkWell(
                                          child: Text("Follow",style: TextStyle(fontSize: 14,color: appColor),),
                                        )
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
                                Icon(Icons.location_on_outlined),
                                Text(data['Destination'],style: TextStyle(fontSize: 18),)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(formatDate(data['StartDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 18),),
                                Icon(Icons.calendar_month_sharp),
                                Text(formatDate(data['EndDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 18),)
                              ],
                            ),
                            Divider(thickness: 1,),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => userChat()));
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
                    );
                  },

                );
              },
              
            ),
          ),
        )

    );
  }
}
