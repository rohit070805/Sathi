import 'package:flutter/material.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/userChat.dart';
class chatList extends StatefulWidget {
  const chatList({super.key});

  @override
  State<chatList> createState() => _chatListState();
}

class _chatListState extends State<chatList> {
  var time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: const Text("C H A T",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5,right: 5),
        child:  ListView.builder(
        itemCount: 20,
    itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => userChat()));

            },

            child: ListTile(
              leading:  Icon(Icons.account_circle_rounded,color: Colors.grey,size: 55,),
                title: Text("USERX",style: TextStyle(color: Colors.black),),
              subtitle: Text("Last message",style: TextStyle(color: Colors.black)),
              trailing:  Text('${time.hour}:${time.minute}')),
          );
    },
      ),)
    );
  }
}
