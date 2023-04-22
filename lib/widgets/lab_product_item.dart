import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_labs_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/add_product_screen.dart';
import '../providers/labs.dart';
import '../screens/manage_labs_screen.dart';
import '../screens/edit_labs_screen.dart';

class LabProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  LabProductItem(this.id, this.title, this.imageUrl);

  Future<void> _deleteLab(String id) async {
    var db = FirebaseFirestore.instance;
    try {
      await db.collection("labtest").doc(id).delete();
    } catch (err) {
      print(err);
    }
  }

  var _isLoading;
  double price;
  String description;
  String name;
  String url;
  Future<void> _editProduct(String id) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('labtest').doc(id).get();
    name = (document.data() as Map<String, dynamic>)['Name'];
    description = (document.data() as Map<String, dynamic>)['Description'];
    price = (document.data() as Map<String, dynamic>)['Price'];
    url = (document.data() as Map<String, dynamic>)['Image'];
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await _editProduct(id);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditLabsScreen(
                        labId: id,
                        name: name,
                        price: price,
                        description: description,
                        url: url)));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await _deleteLab(id);
                } catch (error) {
                  print(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
