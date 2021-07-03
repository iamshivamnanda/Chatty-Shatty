import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message-bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('/Chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, streamsnapshot) {
        if (streamsnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final mydocuments = streamsnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => Container(
            // padding: EdgeInsets.all(8),
            child: MessageBubble(
                mydocuments[index]['text'],
                (mydocuments[index]['userId'] ==
                    FirebaseAuth.instance.currentUser.uid),
                ValueKey(
                  mydocuments[index].documentID,
                ),
                mydocuments[index]['username'],
                mydocuments[index]['imageurl']),
          ),
          itemCount: streamsnapshot.data.documents.length,
        );
      },
    );
  }
}
