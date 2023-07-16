import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/details_screen.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart' as pr;
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<pr.Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final images =
        Provider.of<Products>(context, listen: false).images(product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                PageProfileBoutique.route,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage(
                  'assets/images/drug.png',
                ),
                image: NetworkImage(product.imageUrl),
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
                  "GHS ${product.price}",
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
                  product.title,
                  style: TextStyle(color: Colors.black),
                  //overflow: TextOv,
                  //textAlign: TextAlign.center,
                  softWrap: true,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added item to cart!',
                        ),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
