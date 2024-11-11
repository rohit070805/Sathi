import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sathi/SideMenuBar.dart';
import 'package:sathi/chatList.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firebase_auth_services.dart';

class ProfilePage extends StatefulWidget {


  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuthServices();
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String? displayName = _auth.getUserName();

    return Scaffold(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => chatList()));

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle_rounded,color: Colors.grey,size: 100,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName!,style: TextStyle(fontSize: 30),),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("10",style: TextStyle(fontSize: 20),),
                                    Text("Trips",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(width: 20,),

                                Column(
                                  children: [
                                    Text("10",style: TextStyle(fontSize: 20)),
                                    Text("Followers",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  children: [
                                    Text("10",style: TextStyle(fontSize: 20)),
                                    Text("Following",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
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
          SliverGrid(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1,
          ),
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              return const Card(
                color: Colors.white,
                shadowColor: Colors.black,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          Text("Una",style: TextStyle(fontSize: 18),),
                          Icon(Icons.location_on_outlined),
                          Text("Delhi",style: TextStyle(fontSize: 18),)

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("26/8/24",style: TextStyle(fontSize: 16),),
                          Icon(Icons.calendar_month_sharp),
                          Text("30/8/24",style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Members - 3",style: TextStyle(fontSize: 16),),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
                childCount: 10

            ),

          ),


        ],
      ),
    );
  }
}