import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import 'add_lab_service.dart';
import '../widgets/lab_product_item.dart';
import './menu_screen.dart';

class ManageLabs extends StatelessWidget {
  static const routeName = '/manageLabs';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    //print('rebuilding...');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Available Labs'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddLabService.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('labtest').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> labtestSnapshot) {
            if (labtestSnapshot.connectionState == ConnectionState.waiting) {
              return SpinKitDualRing(color: Theme.of(context).primaryColor);
            }
            final lab = labtestSnapshot.data.docs;

            return ListView.builder(
                itemCount: lab.length,
                itemBuilder: (context, index) => LabProductItem(
                    (lab[index].data() as Map<String, dynamic>)['id'],
                    (lab[index].data() as Map<String, dynamic>)['Name'],
                    (lab[index].data() as Map<String, dynamic>)['Image']));
          },
        ));
  }
}
