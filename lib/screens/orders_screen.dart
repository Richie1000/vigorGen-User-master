import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/orders.dart' as ord;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import './menu_screen.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
   String userId(){
      var auth = Provider.of<Auth>(context, listen: false);
      String newString = auth.userId;
      return newString;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: userId()).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
            if (ordersSnapshot.connectionState == ConnectionState.waiting) {
              return SpinKitDualRing(color: Theme.of(context).primaryColor);
            }
            if (!ordersSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final loadedOrders = ordersSnapshot.data.docs;
            //print(lab);

            return ListView.builder(
  itemCount: loadedOrders.length,
  itemBuilder: (context, index) {
    var array = (loadedOrders[index].data() as Map<String, dynamic>)['cartItems'];
    List<dynamic> cartItems = List<dynamic>.from(array);
    List<CartItem> products = cartItems.map((item) => CartItem.fromJson(item)).toList();
    return OrderItem(
      id: (loadedOrders[index].data() as Map<String, dynamic>)['id'],
      completed: (loadedOrders[index].data() as Map<String, dynamic>)['isDelivered'],
      amount: (loadedOrders[index].data() as Map<String, dynamic>)['price'],
      dateTime: (loadedOrders[index].data() as Map<String, dynamic>)['dateTime'],
      products: products,
    );
  },
);

          },
        ),
    );
  }
}
