import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:sathi/colors.dart';
import 'main.dart';

class aichatscreen extends StatefulWidget {
  const aichatscreen({super.key});

  @override
  State<aichatscreen> createState() => _aichatscreenState();
}

class _aichatscreenState extends State<aichatscreen> {
  final Gemini gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(id: "0",firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1",firstName: "Seire" );

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
        title: const Text("S e i r e",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: buildUI(),
    );

  }
  Widget buildUI(){
    return DashChat(currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: const MessageOptions(
        currentUserContainerColor: Colors.blueAccent
    ),);
  }
  void _sendMessage(ChatMessage chatMessage){
   setState(() {
     messages = [chatMessage, ...messages];});
   String question = chatMessage.text;
   try{
     gemini.streamGenerateContent(question).listen((event) {
       ChatMessage? lastMessage = messages.firstOrNull;
       if (lastMessage != null && lastMessage.user == geminiUser) {
         lastMessage = messages.removeAt(0);
         String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ??
             "";lastMessage.text += response;
         setState(
               () {
             messages = [lastMessage!, ...messages];},);
       } else {
         String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
         ChatMessage message = ChatMessage(
           user: geminiUser,
           createdAt: DateTime.now(),
           text: response,
         );
         setState(() {
           messages = [message, ...messages];
         });}});} catch(e){
     print(e);}}}
