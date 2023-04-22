import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import './checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  String getCurrency() {
    var format =
        NumberFormat.currency(locale: Platform.localeName, name: 'GHS');
    print(format);
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      getCurrency() + ' ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
          if (cart.itemCount != 0)
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, CheckOutScreen.routeName);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              child: Text(
                "Proceed",
                style: TextStyle(fontSize: 20),
              ),
            )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              // await Provider.of<Orders>(context, listen: false).addOrder(
              //   widget.cart.items.values.toList(),
              //   widget.cart.totalAmount,
              // );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              showBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.white70,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.check_circle,
                      size: 70,
                      color: Colors.green,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Center(
                            child: Text(
                              "Thanks For shopping with us! \nYou will be notified when we are about to Deliver",
                              softWrap: true,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    ),
                  ]),
                ),
              );
            },
      //textColor: Theme.of(context).primaryColor,
    );
  }
}
