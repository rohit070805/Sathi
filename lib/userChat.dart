import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sathi/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userchat extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  Userchat({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  _UserchatState createState() => _UserchatState();
}

class _UserchatState extends State<Userchat> {
  List<ChatMessage> messages = [];

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '${user1}$user2' : '${user2}$user1';
  }

  Future<void> sendMessage(ChatMessage message) async {
    String chatId = getChatId(widget.currentUserId, widget.otherUserId);

    FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'users': [widget.currentUserId, widget.otherUserId],
      'lastMessage': message.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
  }

  Stream<List<ChatMessage>> getMessages() {
    String chatId = getChatId(widget.currentUserId, widget.otherUserId);

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
  }

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
        title: Text("${widget.otherUserName}",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Padding(

        padding: const EdgeInsets.only(left: 5,right: 5),
        child: StreamBuilder<List<ChatMessage>>(
          stream: getMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return DashChat(

              messageOptions: MessageOptions(
                showOtherUsersAvatar: false,
                showOtherUsersName: false,
                currentUserTextColor: Colors.black,
                currentUserContainerColor: Color(0xFFD6D6D6),
                containerColor: appColor,
                textColor: Colors.white
              ),
              messages: snapshot.data!,
              currentUser: ChatUser(
                id: widget.currentUserId,
                firstName: "You",
              ),
              onSend: sendMessage,
            );
          },
        ),
      ),
    );
  }
}
