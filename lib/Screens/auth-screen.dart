import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../widgets/auth/auth-form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
  final Future<void> _intilization = Firebase.initializeApp();

  final _auth = FirebaseAuth.instance;
  void submitauthform(String email, String username, String password,
      bool islogin, File image) async {
    UserCredential _usercredention;
    try {
      setState(() {
        _isloading = true;
      });
      if (islogin) {
        _usercredention = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _usercredention = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_usercredention.user.uid + '.jpg');
        await ref.putFile(image).whenComplete(() => null);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_usercredention.user.uid)
            .set({'username': username, 'email': email, 'imageurl': url});
      }
    } on PlatformException catch (error) {
      var message = 'An Error Occured,please check tour credentionals';
      if (error.message != null) {
        message = error.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (error) {
      print(error);
      var message = 'An Error Occured,please check tour credentionals';
      if (error.message != null) {
        message = error.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _intilization,
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? CircularProgressIndicator()
          : Container(
              child: Scaffold(
                // backgroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.transparent,
                body: AuthForm(submitauthform, _isloading),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Colors.red,
                Colors.amberAccent,
              ])),
            ),
    );
  }
}
