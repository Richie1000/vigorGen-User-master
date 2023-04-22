import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/image_picker.dart';
import '../providers/labtest.dart';
import '../providers/labs.dart';
import '../widgets/app_drawer.dart';

class AddLabService extends StatefulWidget {
  //const AddLabService({ Key? key }) : super(key: key);
  static const routeName = "./addLab";

  @override
  State<AddLabService> createState() => _AddLabServiceState();
}

class _AddLabServiceState extends State<AddLabService> {
  final _form = GlobalKey<FormState>();
  XFile _pickedImage;
  var _editedLab = LabTest(
    id: null,
    title: '',
    price: 0,
    description: '',
    labImage: null,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'labImage': '',
  };
  var _isInit = true;
  var _isLoading = false;

  void _selectImage(XFile image) {
    _pickedImage = image;
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    DateTime dateId = DateTime.now();
    DateTime formattedDate = new DateTime(dateId.day, dateId.month, dateId.year,
        dateId.hour, dateId.minute, dateId.millisecond);
    String newId = ("LABTEST/$formattedDate");
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedLab.id != null) {
      // await Provider.of<LabTest>(context, listen: false)
      //     .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('lab_image')
            .child(DateTime.now().toIso8601String() + '.jpg');

        //manipulating ref to a future so as to await it
        final File newFile = File(_pickedImage.path);
        await ref.putFile(newFile);

        //getting image url to work on
        final url = await ref.getDownloadURL();
        //_imageUrlController.text = url;
        _editedLab.labImage = url;
        _editedLab.id = newId;
        print(_editedLab.description);
        print(_editedLab.labImage);
        print(_editedLab.price);
        print(_editedLab.id);
        var docRef =
            await FirebaseFirestore.instance.collection('labtest').add({
          'id': _editedLab.id,
          'Name': _editedLab.title,
          'Price': _editedLab.price,
          'Description': _editedLab.description,
          'Image': _editedLab.labImage
        });
        var documentId = docRef.id;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lab Added succesfully"),
          duration: Duration(milliseconds: 3000),
        ));
        // await Provider.of<Labs>(context, listen: false)
        //     .addLab(_editedLab);
        docRef.update({
          'id': documentId,
        });
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Add Lab Service"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        //initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocusNode);
                        // },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedLab = LabTest(
                            title: value,
                            price: _editedLab.price,
                            description: _editedLab.description,
                            labImage: _editedLab.labImage,
                            id: _editedLab.id,
                          );
                        },
                      ),
                      TextFormField(
                        //initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        //focusNode: _priceFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context)
                        //       .requestFocus(_descriptionFocusNode);
                        // },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedLab = LabTest(
                            title: _editedLab.title,
                            price: double.parse(value),
                            description: _editedLab.description,
                            labImage: _editedLab.labImage,
                            id: _editedLab.id,
                          );
                        },
                      ),
                      TextFormField(
                        //initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        //focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedLab = LabTest(
                            title: _editedLab.title,
                            price: _editedLab.price,
                            description: value,
                            labImage: _editedLab.labImage,
                            id: _editedLab.id,
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(child: UserImagePicker(_selectImage))
                          ]),

                      // Expanded(
                      //   child: TextFormField(
                      //     decoration: InputDecoration(labelText: 'Image URL'),
                      //     keyboardType: TextInputType.url,
                      //     textInputAction: TextInputAction.done,
                      //     controller: _imageUrlController,
                      //     focusNode: _imageUrlFocusNode,
                      //     onFieldSubmitted: (_) {
                      //       _saveForm();
                      //     },
                      //     validator: (value) {
                      //       if (value.isEmpty) {
                      //         return 'Please enter an image URL.';
                      //       }
                      //       if (!value.startsWith('http') &&
                      //           !value.startsWith('https')) {
                      //         return 'Please enter a valid URL.';
                      //       }
                      //       if (!value.endsWith('.png') &&
                      //           !value.endsWith('.jpg') &&
                      //           !value.endsWith('.jpeg')) {
                      //         return 'Please enter a valid image URL.';
                      //       }
                      //       return null;
                      //     },
                      //     onSaved: (value) {
                      //       _editedProduct = Product(
                      //         title: _editedProduct.title,
                      //         price: _editedProduct.price,
                      //         description: _editedProduct.description,
                      //         imageUrl: value,
                      //         id: _editedProduct.id,
                      //         isFavorite: _editedProduct.isFavorite,
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ));
  }
}
