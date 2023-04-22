import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';

import '../widgets/lab_Item.dart';
import '../widgets/app_drawer.dart';
import '../screens/lab_cart_screen.dart';
import '../providers/lab_cart.dart';
import './lab_request_details_screen.dart';
import './lab_cart_screen.dart';
import './menu_screen.dart';

class LabScreen extends StatelessWidget {
  static const routeName = "./LabScreen";
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LabCartScreen.routeName);
                  // Navigator.of(context).pushNamed(LabRequestDetailsScreen.routeName);
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormScreen()));
                },
              ),
            ],
            title: Text("Vigor Gen"),
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light),
        drawer: AppDrawer(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('labtest').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> labtestSnapshot) {
            if (labtestSnapshot.connectionState == ConnectionState.waiting) {
              return SpinKitDualRing(color: Theme.of(context).primaryColor);
            }
            if (!labtestSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final lab = labtestSnapshot.data.docs;
            //print(lab);

            return ListView.builder(
              itemCount: lab.length,
              itemBuilder: (context, index) => LabItem(
                id: (lab[index].data() as Map<String, dynamic>)['id'],
                title: (lab[index].data() as Map<String, dynamic>)['Name'],
                description:
                    (lab[index].data() as Map<String, dynamic>)['Description'],
                price: (lab[index].data() as Map<String, dynamic>)['Price'],
              ),
            );
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).primaryColorLight,
        //   child: Consumer<Cart>(
        //     builder: (_, cart, ch) => Badge(
        //       child: ch,
        //       value: cart.itemCount.toString(),
        //     ),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.shopping_cart,
        //       ),
        //       onPressed: () {
        //         onPressed:
        //         () {
        //           Navigator.of(context)
        //               .pushReplacementNamed(LabCartScreen.routeName);
        //           // Navigator.of(context).pushNamed(LabRequestDetailsScreen.routeName);
        //           //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormScreen()));
        //         };
        //       },
        //     ),
        //   ),
        // ),
        );
  }
}
