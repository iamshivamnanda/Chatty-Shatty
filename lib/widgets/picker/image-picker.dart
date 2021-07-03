import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedimage) imagepickfn;
  UserImagePicker(this.imagepickfn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedimage;
  void pickimage() async {
    final picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose A Source'),
        actions: [
          FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.camera),
            label: Text('Camera'),
            onPressed: () async {
              final _picked = await picker.getImage(
                source: ImageSource.camera,
                imageQuality: 70,
                maxWidth: 200,
              );
              Navigator.of(context).pop();
              setState(() {
                pickedimage = File(_picked.path);
              });
              widget.imagepickfn(pickedimage);
            },
          ),
          FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.image),
            label: Text('Gallery'),
            onPressed: () async {
              final _picked = await picker.getImage(
                source: ImageSource.gallery,
                imageQuality: 70,
                maxWidth: 200,
              );
              Navigator.of(context).pop();

              setState(() {
                pickedimage = File(_picked.path);
              });
              widget.imagepickfn(pickedimage);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: pickedimage == null ? null : FileImage(pickedimage),
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: pickimage,
        )
      ],
    );
  }
}
