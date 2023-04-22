import 'package:flutter/material.dart';
import './product_shimmer.dart';

class ShimmerGid extends StatelessWidget {
  //const ShimmerGid({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
     final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
     return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 10,
      itemBuilder: (ctx, i) => ProductShimmer(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}