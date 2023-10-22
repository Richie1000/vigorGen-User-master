import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'details_screen.dart';

class CategoryProductScreen extends StatelessWidget {
  final String category;

  CategoryProductScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }
          final products = snapshot.data.docs;
          if (products.isEmpty) {
            return Center(
              child: Text('No products found for this category.'),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              final product = products[index].data() as Map<String, dynamic>;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          PageProfileBoutique.route,
                          arguments: product['otherID'],
                        );
                      },
                      child: Hero(
                        tag: product['otherID'],
                        child: FadeInImage(
                          placeholder: AssetImage(
                            'assets/images/drug.png',
                          ),
                          image: NetworkImage(product['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      )),
                  footer: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5),
                          //borderRadius: BorderRadius.circular(20)
                        ),
                        child: GridTileBar(
                          subtitle: Text(
                            "GHS ${product['price'].toString()}",
                            style: TextStyle(color: Colors.black),
                          ),
                          //backgroundColor: Colors.black87,
                          // leading: Text("GHS ${product.price}", style: TextStyle(
                          //   color: Colors.white
                          // ) ,),
                          // leading: Consumer<Product>(
                          //   builder: (ctx, product, _) => IconButton(
                          //         icon: Icon(
                          //           product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          //         ),
                          //         color: Theme.of(context).accentColor,
                          //         onPressed: () {
                          //           product.toggleFavoriteStatus(
                          //             authData.token,
                          //             authData.userId,
                          //           );
                          //         },
                          //       ),
                          // ),
                          title: Text(
                            product['title'],
                            style: TextStyle(color: Colors.black),
                            //overflow: TextOv,
                            //textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          // trailing: IconButton(
                          //   icon: Icon(
                          //     Icons.shopping_cart,
                          //   ),
                          //   onPressed: () {
                          //     //cart.addItem(product.id, product.price, product.title);
                          //     //ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          //     // ScaffoldMessenger.of(context).showSnackBar(
                          //     //   SnackBar(
                          //     //     content: Text(
                          //     //       'Added item to cart!',
                          //     //     ),
                          //     //     duration: Duration(seconds: 2),
                          //     //     action: SnackBarAction(
                          //     //       label: 'UNDO',
                          //     //       onPressed: () {
                          //     //         //cart.removeSingleItem(product.id);
                          //     //       },
                          //     //     ),
                          //     //   ),
                          //     // );
                          //   },
                          //   color: Theme.of(context).accentColor,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              // return Card(
              //   child: Column(
              //     children: [
              //       Expanded(
              //         child: Image.network(
              //           product['imageUrl'],
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //       ListTile(
              //         title: Text(product['title']),
              //         subtitle: Text('GHS ${product['price']}'),
              //       ),
              //     ],
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
