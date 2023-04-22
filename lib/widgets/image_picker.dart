import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(XFile pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();
  var isOpen = false;

  void _pickImageFromCamera() async {
    final XFile pickedImageFile =
        (await ImagePicker().pickImage(source: ImageSource.camera));
    final File file = File(pickedImageFile.path);
    setState(() {
      _pickedImage = file;
    });
    widget.imagePickFn(pickedImageFile);
    Navigator.of(context).pop();
  }

  void _pickImageFromGallery() async {
    final XFile pickedImageFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    final File file = File(pickedImageFile.path);
    setState(() {
      _pickedImage = file;
    });
    widget.imagePickFn(pickedImageFile);
    Navigator.of(context).pop();
  }

  void _showPrompt() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Pick Image From"),
              actions: [
                TextButton(
                    onPressed: _pickImageFromCamera, child: Text("Camera")),
                TextButton(
                  onPressed: _pickImageFromGallery,
                  child: Text("Gallery"),
                )
              ],
            ));
  }

  void _showModalSheet() {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Wrap(children: [
        Column(
          children: [
            TextButton(
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(width: 5),
                    Text("Camera")
                  ],
                ),
                onPressed: _pickImageFromCamera),
            Divider(),
            TextButton(
                onPressed: _pickImageFromGallery,
                child: Row(children: [
                  Icon(Icons.file_open_outlined),
                  SizedBox(width: 5),
                  Text("Gallery")
                ])),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ])
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: double.infinity,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage as File) : null,
          ),
        ),
        TextButton.icon(
          //textColor: Theme.of(context).primaryColor,
          onPressed: _showModalSheet,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    ));
  }
}
