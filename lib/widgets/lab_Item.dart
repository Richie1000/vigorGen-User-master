import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/lab_cart.dart';

class LabItem extends StatefulWidget {
  final String title;
  final String description;
  final double price;
  var id;

  LabItem(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.id});
  @override
  _LabItemState createState() => _LabItemState();
}

class _LabItemState extends State<LabItem> {
  bool isExpanded = true;
  bool isExpanded2 = true;
  var currSymbol = "";

  String getCurrency() {
    var format =
        NumberFormat.currency(locale: Platform.localeName, name: 'GHS');
    print(format);
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String description = widget.description;
    return Column(children: [
      InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          margin: EdgeInsets.symmetric(
            horizontal: isExpanded ? 20 : 0,
            vertical: 15,
          ),
          padding: EdgeInsets.all(20),
          height: isExpanded ? 120 : 330,
          width: MediaQuery.of(context).size.width - 15,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1200),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor,
                blurRadius: 20,
                offset: Offset(5, 10),
              ),
            ],
            color: Color(0xffFF5050),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 27,
                  ),
                ],
              ),
              isExpanded ? SizedBox() : SizedBox(height: 20),
              AnimatedCrossFade(
                firstChild: 
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 0,
                  ),
                ),
                secondChild: Column(
                  children: [
                    Text(
                      isExpanded? "" : description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.7,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          getCurrency() + '${widget.price}',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                        IconButton(
                            icon: Icon(Icons.shopping_cart),
                            onPressed: () {
                              Provider.of<LabCart>(context, listen: false)
                                  .addLabItem(
                                      widget.id, widget.price, widget.title);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Added item to cart!',
                                ),
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    Provider.of<LabCart>(context, listen: false)
                                        .removeItem(widget.id);
                                  },
                                ),
                              ));
                            }),
                      ],
                    )
                  ],
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 1500),
                reverseDuration: Duration.zero,
                sizeCurve: Curves.fastLinearToSlowEaseIn,
              ),
            ],
          ),
        ),
      ),
      // InkWell(
      //   highlightColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      //   onTap: () {
      //     setState(() {
      //       isExpanded2 = !isExpanded2;
      //     });
      //   },
      //   child: AnimatedContainer(
      //     margin: EdgeInsets.symmetric(
      //       horizontal: isExpanded2 ? 25 : 0,
      //       vertical: 20,
      //     ),
      //     padding: EdgeInsets.all(20),
      //     height: isExpanded2 ? 70 : 330,
      //     curve: Curves.fastLinearToSlowEaseIn,
      //     duration: Duration(milliseconds: 1200),
      //     decoration: BoxDecoration(
      //       boxShadow: [
      //         BoxShadow(
      //           color: Color(0xffFF5050).withOpacity(0.5),
      //           blurRadius: 20,
      //           offset: Offset(5, 10),
      //         ),
      //       ],
      //       color: Color(0xffFF5050),
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(isExpanded2 ? 20 : 0),
      //       ),
      //     ),
      //     child: Column(
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               TapToExpandIt,
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 22,
      //                 fontWeight: FontWeight.w400,
      //               ),
      //             ),
      //             Icon(
      //               isExpanded2
      //                   ? Icons.keyboard_arrow_down
      //                   : Icons.keyboard_arrow_up,
      //               color: Colors.white,
      //               size: 27,
      //             ),
      //           ],
      //         ),
      //         isExpanded2 ? SizedBox() : SizedBox(height: 20),
      //         AnimatedCrossFade(
      //           firstChild: Text(
      //             '',
      //             style: TextStyle(
      //               fontSize: 0,
      //             ),
      //           ),
      //           secondChild: Column(
      //             children: [
      //               Text(
      //                 Sentence,
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 15.7,
      //                 ),
      //               ),
      //               IconButton(
      //                 icon: Icon(Icons.shopping_cart),
      //                 onPressed: (){
      //                   print("Item tapped");
      //                 },
      //               )
      //             ],
      //           ),
      //           crossFadeState: isExpanded2
      //               ? CrossFadeState.showFirst
      //               : CrossFadeState.showSecond,
      //           duration: Duration(milliseconds: 1200),
      //           reverseDuration: Duration.zero,
      //           sizeCurve: Curves.fastLinearToSlowEaseIn,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    ]);
  }
}
