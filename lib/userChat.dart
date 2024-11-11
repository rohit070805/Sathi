import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sathi/colors.dart';
class userChat extends StatefulWidget {
  const userChat({super.key});

  @override
  State<userChat> createState() => _userChatState();
}
List<ChatMessage> usermessages = [];
class _userChatState extends State<userChat> {
  ChatUser currentUser = ChatUser(id: "0",firstName: "User");

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
        title: const Text("User ##1",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: buildUI(),
    );

  }
  Widget buildUI(){
    return DashChat(currentUser: currentUser,
      onSend: _sendMessage,
      messages: usermessages,
      messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.blueAccent
      ),);
  }
  void _sendMessage(ChatMessage chatMessage){
    setState(() {
      usermessages = [chatMessage, ...usermessages];
    });


  }

}
