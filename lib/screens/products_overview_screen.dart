import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/disappearing_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';
import '../widgets/search_button.dart';
import '../widgets/product_shimmer_grid.dart';
import '../widgets/grid_and_category.dart';
import './menu_screen.dart';
import '../widgets/disappearing_appbar.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshHanndler() async {
    return await Provider.of<Products>(context, listen: true)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
      ),
      appBar: CustomAppBar(),
      // AppBar(
      //   //leading: AppDrawer(),
      //   title: Text(
      //     'MEK Pharmacy',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   actions: [SearchButton()],
      //   shadowColor: Colors.white,
      //   elevation: 0,
      //   bottomOpacity: 0,
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      // ),
      //drawer: AppDrawer(),
      body: LiquidPullToRefresh(
          color: Theme.of(context).primaryColor,
          animSpeedFactor: 1.5,
          onRefresh: _refreshHanndler,
          child: _isLoading ? ShimmerGid() : ProductsGrid(false)),
    );
  }
}
