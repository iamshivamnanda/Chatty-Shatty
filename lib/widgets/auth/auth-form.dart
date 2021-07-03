import 'package:flutter/material.dart';
import '../picker/image-picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      bool islogin, File image) submitauthform;
  final bool _isloading;
  AuthForm(this.submitauthform, this._isloading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  String _useremail = '';
  String _username = '';
  String _password = '';
  File _userimagefile;

  void pickimage(File image) {
    _userimagefile = image;
  }

  void _trysubmit() {
    final isvalid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userimagefile == null && !_islogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick An Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isvalid) {
      _formkey.currentState.save();
      widget.submitauthform(
          _useremail, _username, _password, _islogin, _userimagefile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_islogin) UserImagePicker(pickimage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please Enter A Valid EMAIL Address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _useremail = newValue;
                    },
                  ),
                  if (!_islogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: "UserName"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter UserName';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _username = newValue;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value.isEmpty || value.length <= 7) {
                        return "Password must be atleast 7 characters long.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _password = newValue;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget._isloading)
                    CircularProgressIndicator(
                      backgroundColor: Colors.pink,
                    ),
                  if (!widget._isloading)
                    RaisedButton(
                      child: Text(_islogin ? 'Login' : 'SignUp'),
                      onPressed: _trysubmit,
                    ),
                  if (!widget._isloading)
                    FlatButton(
                      child: Text(_islogin
                          ? 'Create New Account'
                          : 'I Already Have An Account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _islogin = !_islogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
