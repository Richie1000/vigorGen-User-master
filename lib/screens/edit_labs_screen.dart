import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/app_drawer.dart';
import '../widgets/image_picker.dart';
import '../providers/labtest.dart';

class EditLabsScreen extends StatefulWidget {
  String labId;
  String name;
  var price;
  String description;
  String url;
  static const routeName = './EditLab';

  EditLabsScreen({
    this.labId = "",
    this.name = "",
    this.price = 0,
    this.description = "",
    this.url = ""
  });

  @override
  State<EditLabsScreen> createState() => _EditLabsScreenState();
}

class _EditLabsScreenState extends State<EditLabsScreen> {
  XFile _pickedImage; 
  final _form = GlobalKey<FormState>();
      bool _isLoading = false;
  var productId;
  var productPrice;
  var productDescription;
  var productName;
  var productUrl;

  
  
  var _editedLab = LabTest(
    id: "", 
    title: "", 
    price: 0, 
    description: "", 
    labImage: "");

  void _selectImage(XFile image){
     _pickedImage = image;
  }  

  @override
  Widget build(BuildContext context) {
    String newPrice = "${widget.price}";

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
      
        title: Text("Add Lab Service"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){},
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
                      initialValue: widget.name,
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
                            id: widget.labId,
                            );
                      },
                    ),
                    TextFormField(
                      initialValue: newPrice ,
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
                            id: widget.labId,
                            );
                      },
                    ),
                    TextFormField(
                      initialValue: widget.description,
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
                          id: widget.labId,
                        
                        );
                      },
                    ),
                    SizedBox(
                      height: 20
                    ),
                    Row(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(child: UserImagePicker(_selectImage ) )
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