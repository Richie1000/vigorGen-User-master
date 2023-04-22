import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import './labtest.dart';

class Labs with ChangeNotifier {
  List <LabTest> _items =[];
  final String authToken;
  final String userId;

  Labs(this.authToken, this.userId, this._items);

  List <LabTest> get items {
    return [..._items];
  }

  LabTest findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addLab(labtest)async{
    final Uri url =
        Uri.parse('https://shop-app-d00fc-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': labtest.title,
          'description': labtest.description,
          'labImage': labtest.imageUrl,
          'price': labtest.price,
        }),
      );
      final newProduct = LabTest(
        title: labtest.title,
        description: labtest.description,
        price: labtest.price,
        labImage: labtest.labImage,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

 
  }
  
  

