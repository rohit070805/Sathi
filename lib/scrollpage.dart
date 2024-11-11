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
        child: Container(
              padding: EdgeInsets.only(left: 5,right: 5),
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context,index){
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
                                  Text("Rohit Choudhary",style: TextStyle(fontSize: 18),),
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
                              Text("3",style: TextStyle(fontSize: 18),)
                            ],
                          ),
        
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Una",style: TextStyle(fontSize: 18),),
                         Icon(Icons.location_on_outlined),
                          Text("Delhi",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("26/8/24",style: TextStyle(fontSize: 18),),
                          Icon(Icons.calendar_month_sharp),
                          Text("30/8/24",style: TextStyle(fontSize: 18),)
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
        
          ),
        ),
      )

    );
  }
}
