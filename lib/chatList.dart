import 'package:flutter/material.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/userChat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  ChatListScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: Text("C H A T S",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var chatDocs = snapshot.data!.docs;

            if (chatDocs.isEmpty) {
              return Center(child: Text("No chats yet"));
            }

            return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                var chatData = chatDocs[index];
                String otherusername = chatData['name'];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey ,
                          child: CircleAvatar(
                            radius: 29,
                            backgroundImage: AssetImage('assets/images/person.png'),
                            backgroundColor: Colors.grey.shade200,
                          )
                      ),
                      title: Text(otherusername),
                      subtitle: Text('Tap to Chat'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Userchat(
                              currentUserId: currentUserId,
                              otherUserId: chatData['uid'],
                              otherUserName: chatData['name'],
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(thickness: 1,)
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
