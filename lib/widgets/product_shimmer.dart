import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  //const ProductShimmer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500],
        highlightColor: Colors.grey[100],
        child: Container(
          child: GridTile(
            child: Image.asset('assets/images/loadingImage.png'),
            footer: GridTileBar(
              //subtitle: Text("GHC"),
              title: Row(
                children: [
                  Container(
                    width: 50,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: 50),
                  Icon(Icons.shopping_cart),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
