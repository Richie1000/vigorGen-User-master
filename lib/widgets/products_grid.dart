import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            items: [
              // Add your discount images here
              Image.asset('assets/images/discount.png'),
              Image.asset('assets/images/discount1.jpg'),
              Image.asset('assets/images/discount2.jpg'),
            ],
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  CategoryItem(
                    categoryImage: 'assets/images/antibacterial.jpg',
                    categoryName: 'Antibacteria',
                  ),
                  CategoryItem(
                    categoryImage: 'assets/images/painkillers.png',
                    categoryName: 'Painkillers',
                  ),
                  CategoryItem(
                    categoryImage: 'assets/images/contraceptives.png',
                    categoryName: 'Contraceptives',
                  ),
                  CategoryItem(
                    categoryImage: 'assets/images/aphrodisiac.jpg',
                    categoryName: 'Aphrodisiac',
                  ),
                ]),
              ),
            ],
          ),
          //SizedBox(height: 10),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String categoryImage;
  final String categoryName;

  const CategoryItem({
    Key key,
    @required this.categoryImage,
    @required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle category tap
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3.7,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              categoryImage,
              width: 50,
              height: 20,
            ),
            SizedBox(height: 5),
            Text(
              categoryName,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
