import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _entermessage = '';
  final _controller = new TextEditingController();
  void _sendmessage() async {
    FocusScope.of(context).unfocus();
    final userdata = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    FirebaseFirestore.instance.collection('/Chat').add({
      'text': _entermessage,
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser.uid,
      'username': userdata['username'],
      'imageurl': userdata['imageurl']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Send a message...."),
            onChanged: (value) {
              setState(() {
                _entermessage = value;
              });
            },
          )),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: (_entermessage.trim().isEmpty) ? null : _sendmessage,
          )
        ],
      ),
    );
  }
}
