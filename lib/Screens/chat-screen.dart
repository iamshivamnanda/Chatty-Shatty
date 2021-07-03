import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import '../widgets/chats/chats.dart';
import '../widgets/chats/new-message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final Future<void> _intilization = Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatty Shatty'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Logout'),
                      // Text('Exit')
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Chats(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
