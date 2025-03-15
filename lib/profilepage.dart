import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sathi/SideMenuBar.dart';
import 'package:sathi/chatList.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firebase_auth_services.dart';
import 'package:sathi/firestor.dart';
import 'package:sathi/followersList.dart';
import 'package:sathi/followingsList.dart';
import 'package:sathi/userModal.dart';

class ProfilePage extends StatefulWidget {


  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: SideMenu(),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
            ),
            pinned: true,
            expandedHeight: 300,
            backgroundColor: appColor,
            leading: IconButton(onPressed: (){
              _drawerkey.currentState?.openDrawer();
            },
                icon: Icon(Icons.menu,color: Colors.white,)),

            actions: [
              Padding(
                padding:  EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(Icons.chat,color: Colors.white,),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListScreen(currentUserId: _auth.currentUser!.uid)));

                  },
              ))
            ],
            //title: Text("S  A  T  H  I",style: TextStyle(color: Colors.white),),
            flexibleSpace: FlexibleSpaceBar(

              background: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(60)),
                child: Container(
                  color:appColor,

                  child: Center(child: Lottie.asset('assets/animations/wave.json',repeat: true),),),
              ),
              title: const Text("S  A  T  H  I",style: TextStyle(color: Colors.white),),



            ),
          ),

          SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 20,top: 20,bottom: 20),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   FutureBuilder(future: Firebase_firestor().getUser(),
                       builder: (context,snapshot){
                     if(!snapshot.hasData){
                       return const Center(child: CircularProgressIndicator(color: Colors.black,),);
                     }
                     Usermodel user = snapshot.data!;

                     return  Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         CircleAvatar(
                             radius: 50,
                             backgroundColor: Colors.grey ,
                             child: CircleAvatar(
                               radius: 49,
                               backgroundImage: AssetImage('assets/images/person.png'),
                               backgroundColor: Colors.grey.shade200,
                             )
                         ),
                         SizedBox(width: 10,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(user.username.toString(),style: TextStyle(fontSize: 30,color: appColor),),

                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Column(
                                   children: [
                                     Text("0",style: TextStyle(fontSize: 20),),
                                     Text("Trips",style: TextStyle(fontSize: 12,))
                                   ],
                                 ),
                                 SizedBox(width: 20,),

                                 InkWell(
                                   onTap:(){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>followersList()));

                         },
                                   child: Column(
                                     children: [
                                       FutureBuilder<int>(
                                         future: Firebase_firestor().getFollowersCount(_auth.currentUser!.uid),
                                         builder: (context, snapshot) {
                                           if (snapshot.connectionState == ConnectionState.waiting) {
                                             return CircularProgressIndicator(color: Colors.black,);
                                           } else if (snapshot.hasError) {
                                             return Text('Error: ${snapshot.error}');
                                           } else {
                                             return Text('${snapshot.data}',style: TextStyle(fontSize: 20));
                                           }
                                         },
                                       ),
                                       Text("Followers",style: TextStyle(fontSize: 12,))
                                     ],
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 InkWell(
                                   onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>followingList()));
                         },
                                   child: Column(
                                     children: [
                                       FutureBuilder<int>(
                                         future: Firebase_firestor().getFollowingCount(_auth.currentUser!.uid),
                                         builder: (context, snapshot) {
                                           if (snapshot.connectionState == ConnectionState.waiting) {
                                             return CircularProgressIndicator(color: Colors.black,);
                                           } else if (snapshot.hasError) {
                                             return Text('Error: ${snapshot.error}');
                                           } else {
                                             return Text('${snapshot.data}',style: TextStyle(fontSize: 20));
                                           }
                                         },
                                       ),

                                       Text("Following",style: TextStyle(fontSize: 12,))
                                     ],
                                   ),
                                 )
                               ],
                             )
                           ],
                         )
                       ],
                     );
                       })
                  ],
                ),
              )
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                    margin:const EdgeInsets.only(left: 10,right: 10),
                    child:const Divider(thickness: 1,)),
                const Text("Recent Trips",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
              ],
            ),),
            StreamBuilder(stream: _firebaseFirestore.collection('posts').where('uid',isEqualTo: _auth.currentUser!.uid).snapshots(),
                builder: (context,snapshot){
              if(!snapshot.hasData){
                return SliverToBoxAdapter(child: const Center(child: CircularProgressIndicator(color: Colors.black,),));
              }

              var snaplength = snapshot.data!.docs.length;
              final posts = snapshot.data!.docs;
              return  SliverGrid(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1,

              ),
                delegate: SliverChildBuilderDelegate((BuildContext context,int index){

                  final post = posts[index];
                  final data = post.data() as Map<String,dynamic>;
                  var member = data['members'].toString();
                  return  InkWell(
                    onLongPress: (){
                      showDialog(context: context,
                          builder: (context)=>
                      AlertDialog(
                        backgroundColor: Colors.white,
                        title: Center(
                          child: Text("Delete Post",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                        content: Text("Post will be deleted Permanentely!!"),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Cancel",style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),),
                          ElevatedButton(onPressed: ()async{
                            try{
                              await  _firebaseFirestore.collection('posts').doc(data['postId']).delete();
                              Navigator.pop(context);
                              setState(() {


                                Fluttertoast.showToast(msg: "Post Deleted", toastLength: Toast.LENGTH_SHORT);
                              });
                            }catch(e){
                              Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT);

                            }
                          }, child: Text("Delete",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                        ],
                      ));


                    },
                    onTap: (){
                      showDialog(context: context,
                          builder: (context)=>CustomDialogWidget(data));
                    },
                    child: Hero(
                      tag: data['postId'],
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Text(data['Starting'].length<=5?data['Starting']:data['Starting'].substring(0,5)+'..',style: TextStyle(fontSize: 12),),
                                  Icon(Icons.location_on_outlined,color: appColor,),
                                  Text(data['Destination'].length<=5?data['Destination']:data['Destination'].substring(0,5)+'..',style: TextStyle(fontSize: 12),)

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(formatDate(data['StartDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 12),),
                                  Icon(Icons.calendar_month_sharp,color: appColor,),
                                  Text(formatDate(data['EndDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 12),)
                                ],
                              ),
                              Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Members - $member",style: TextStyle(fontSize: 16),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                    childCount: snaplength

                ),

              );


                }),
          SliverToBoxAdapter(child: SizedBox(height: 600,))




        ],
      ),
    );
  }
  Widget CustomDialogWidget(Map<String,dynamic> data){
    var member = data['members'].toString();
    return Dialog(
      child: Hero(
        tag: data['postId'],
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(data['Starting'],style: TextStyle(fontSize: 16),),
                  Icon(Icons.location_on_outlined,color: appColor,),
                  Text(data['Destination'],style: TextStyle(fontSize: 16),)

                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(formatDate(data['StartDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 14),),
                  Icon(Icons.calendar_month_sharp,color: appColor,),
                  Text(formatDate(data['EndDate'].toDate(), [yyyy, '-', mm, '-', dd]),style: TextStyle(fontSize: 14),)
                ],
              ),
              SizedBox(height: 30,),
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Members - $member",style: TextStyle(fontSize: 16),),
                ],
              )
            ],
          ),
        ),
      ),
    );
    
  }

}