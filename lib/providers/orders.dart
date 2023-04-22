import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/product.dart';
//import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import './cart.dart';
import './lab_cart.dart';

class OrderItem {
  final String deliveryNumber;
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String customerNumber;
  final String address;
  final String paymentPlatform;
  final bool completed;

  OrderItem({
    @required this.deliveryNumber,
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.customerNumber,
    @required this.address,
    @required this.paymentPlatform,
    @required this.completed
  });
}

class LabOrderItem {
  final String id;
  final double amount;
  final List<LabCartItem> products;
  final DateTime dateTime;

  LabOrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<LabOrderItem> _laborders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<LabOrderItem> get labOrders {
    return [..._laborders];
  }

  String DeliveryNumber() {
  var rng = Random();
  const letters = 'abcdefghijklmnopqrstuvwxyz';
  return String.fromCharCodes(
    List.generate(
      11,
      (_) => letters.codeUnitAt(rng.nextInt(letters.length)),
    ),
  );
}

  Future<void> fetchAndSetOrders() async {
    final Uri url = Uri.parse('https://shop-app-d00fc-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          completed: orderData['completed'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total, String contact, String address, String payment) async {
    DateTime myDateTime = DateTime.now();
DateFormat myDateFormat = DateFormat('yyyy-MM-dd');
var newDate = myDateFormat.format(myDateTime);
    try {
      Map<String, dynamic> _cartproducts = {};
      int numberofProducts =cartProducts.length;

      List allCartProducts = [];

      //cartProducts.forEach()
      cartProducts.forEach((element) {
        _cartproducts.addAll({'id': element.id, 'price': element.price, 'quantity': element.quantity, 'title': element.title});
        allCartProducts.add(_cartproducts);
      },);
      print(allCartProducts);
        var docRef =
            await FirebaseFirestore.instance.collection('orders').add({
          'id': '',
          'price': total,
          'cartItems': allCartProducts,
          'contact': contact,
          'address': address,
          'paymentMethod': payment,
          'isDelivered': false,
          'userId': userId,
          'dateTime' : DateTime.now().toIso8601String(),
          'date': newDate,
          'numberofProducts': cartProducts.length
        });
        var documentId = docRef.id;
        print(userId);

        // .of(context).showSnackBar(SnackBar(
        //   content: Text("Lab Added succesfully"),
        //   duration: Duration(milliseconds: 3000),
        // ));
        // await Provider.of<Labs>(context, listen: false)
        //     .addLab(_editedLab);
        docRef.update({
          'id': documentId,
        });
      } catch (error) {
        print(error);
        // await showDialog(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: Text('An error occurred!'),
        //     content: Text('Something went wrong.'),
        //     actions: <Widget>[
        //       TextButton(
        //         child: Text('Okay'),
        //         onPressed: () {
        //           Navigator.of(ctx).pop();
        //         },
        //       )
        //     ],
        //   ),
        // );
      }
  }

   Future<void> addOrderAdmin(List<CartItem> cartProducts, double total, String contact, String address, String payment) async {
    print('done');
  }

  Future<void> getDeliveryStatus(deliveryNumber)async{
    print('trying to get it');
    try{
    final Uri url = Uri.parse('https://shop-app-d00fc-default-rtdb.firebaseio.com/orders/$deliveryNumber.json?auth=$authToken');
    final response = await http.get(url);
    final deliveryStatus = json.decode(response.body) as bool;
    print(deliveryStatus);
    //return deliveryStatus;
    }
    catch(err){
      print(err);
    }
  }

  Future<void> addLabOrder(List<LabCartItem> cartProducts, double total) async {
    final Uri url = Uri.parse('https://shop-app-d00fc-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _laborders.insert(
      0,
      LabOrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future <void> addOrderCompletion( String id)async{
    try {
   
    final Uri url = Uri.parse('https://shop-app-d00fc-default-rtdb.firebaseio.com/orders/$userId/$id.json?auth=$authToken');
    await http.patch(url, body: 
      json.encode(
       { 'completed': true}
      )
     );
  } catch (error) {
    print(error);
  }
  }

  String userID(){
    return userId;
  }
}
