import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/product_detail_screen.dart';

class SearchButton extends StatelessWidget {
  //const SearchButton({ Key? key }) : super(key: key);
  var allProducts;

  @override
  Widget build(BuildContext context) {
    var allProducts = Provider.of<Products>(context).fetchAndSetProducts();
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: (){
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {

  
  
  @override
  List<Widget> buildActions(BuildContext context) {
    var allProducts  = Provider.of<Products>(context).searchingElements();
    var searchItems = allProducts;
    return [
      //For Clearing The Query
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  //For Leaving the Search Bar
  @override
  Widget buildLeading(BuildContext context) {
    var allProducts  = Provider.of<Products>(context).searchingElements();
    var searchItems = allProducts;
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var allProducts  = Provider.of<Products>(context).searchingElements();
    var searchItems = allProducts;
    var searchItemsId = [];
    
    List<String> matchQuery = [];
    //example of looping through list
    for (var Product in searchItems) {
      if (Product.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(Product.title);
        searchItemsId.add(Product.id);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          var resultId = searchItemsId[index];
          return ListTile(
            title: Text(result),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(ProductDetailScreen.routeName, arguments: resultId);
            },
          );
        },
        itemCount: matchQuery.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var allProducts  = Provider.of<Products>(context).searchingElements();
    var searchItems = allProducts;
    List<String> matchQuery = [];
    List<String> searchItemsId = [];
    //example of looping through list
    for (var Product in searchItems) {
      if (Product.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(Product.title);
        searchItemsId.add(Product.id);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          var resultId = searchItemsId[index];
          return ListTile(
            title: Text(result),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(ProductDetailScreen.routeName, arguments: resultId);
            },
          );
        },
        itemCount: matchQuery.length);
  }
}