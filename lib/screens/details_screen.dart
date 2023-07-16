// Copyright 2020 Logica Booleana Authors

// import
import 'package:flutter/material.dart';
// Los link de de las depedencias se pueden encontrar en el apartado => Dependencias
//import 'package:desingapp/src/utils/widgets/widgets_utils_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

// README
// Esta es una ui creada para una tienda online de ropa de moda
// FEATURES
// ui created by @logica.booleana
// theme: dark/light
// animation: false
// interactivity: true

// Data
List<String> list = [
  "https://katherinecalnan.com/wp-content/uploads/2014/12/fashion-photographer-canada-women.jpg",
  "https://i.pinimg.com/originals/52/03/fa/5203fab2aa8646688077635863cda0bb.jpg",
  "https://img.freepik.com/foto-gratis/retrato-bella-modelo-sonriente-vestida-pantalones-cortos-verano-hipster-jeans-ropa_158538-3201.jpg?size=626&ext=jpg",
];

// Creamos un obj
class Product {
  // ignore: non_constant_identifier_names
  final String id, title, price, description, url_image;
  // ignore: non_constant_identifier_names
  Product(
      {@required this.id,
      @required this.title,
      this.description = "",
      this.price = "",
      this.url_image = ""});
  Product.jsonConvert(Map<dynamic, dynamic> map)
      : this.id = map['id'],
        this.title = map['title'],
        this.price = map['price'],
        this.description = map['description'],
        this.url_image = map['url_image'];
}

class PageProfileBoutique extends StatefulWidget {
  static const route = "/test";

  final String title;
  final String description;
  final double price;
  final String imageUrl;

  PageProfileBoutique(
      {Key key, this.title, this.description, this.price, this.imageUrl})
      : super(key: key);

  @override
  _PageProfileBoutiqueState createState() => _PageProfileBoutiqueState();
}

class _PageProfileBoutiqueState extends State<PageProfileBoutique> {
  // var
  Product product;
  Color colorIcon = Colors.white;
  Color colorIconText = Colors.black;
  Color colorText = Colors.black;
  Color colorAccent = Colors.purple;
  MaterialColor colorCanvas = Colors.grey;
  MaterialColor colorFond;
  int positionWaist = 0, positionColor = 1;

  double price;
  String title;
  String product_description;
  String url;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    // set

    title = loadedProduct.title;
    price = loadedProduct.price;
    product_description = loadedProduct.description;
    url = loadedProduct.imageUrl;
    product = Product(
        id: "35346",
        title: "berrylush",
        description: "Precio incluido",
        price: "430",
        url_image: list[(positionColor - 1)]);
    // get - values
    colorText = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    colorIcon = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    colorIconText = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return Scaffold(
      backgroundColor: colorCanvas[
          Theme.of(context).brightness == Brightness.dark ? 900 : 100],
      body: body(context: context),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 3.0,
          backgroundColor: colorAccent,
          foregroundColor: Colors.black,
          onPressed: () {
            try {
              Provider.of<Cart>(context, listen: false).addItem(
                  loadedProduct.id, loadedProduct.price, loadedProduct.title);
              HapticFeedback.lightImpact();
              void showSnackbar(BuildContext context, String message) {
                final snackBar = SnackBar(
                  content: Text(message),
                  duration: Duration(seconds: 2),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              showSnackbar(context, "Item added");
            } catch (error) {
              print(error);
            }
          },
          icon: Icon(Icons.shopping_bag_outlined, color: Colors.white),
          label: Text('Add To cart', style: TextStyle(color: Colors.white))),
    );
  }

  // WIDGETS VIEWS
  Widget body({@required BuildContext context}) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          sliverAppBar(context: context),
        ];
      },
      body: description(context: context),
    );
  }

  SliverAppBar sliverAppBar({@required BuildContext context}) {
    // values
    final screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: colorCanvas[
          Theme.of(context).brightness == Brightness.dark ? 900 : 100],
      pinned: false, stretch: true, snap: false, toolbarHeight: 70.0,
      expandedHeight: screenSize.height *
          0.5, // El tamaño de la barra de aplicaciones cuando está completamente expandido */
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        title: Text('', style: TextStyle(color: Colors.white)),
        // muestra una tarjeta redondeada con una imagen que ocupa el %40 de la pantalla en el FlexibleSpaceBar en la propiedad background
        background: Card(
            color: Colors.transparent,
            elevation: 8.0,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(bottom: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: CachedNetworkImage(
                imageUrl: url,
                fadeInDuration: Duration(milliseconds: 500),
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)))),
      ),
      leading: buttonRoundAppBar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          context: context,
          icon: Icons.arrow_back,
          edgeInsets: EdgeInsets.all(8.0)),
      actions: [
        // buttonRoundAppBar(
        //     onPressed: () {},
        //     context: context,
        //     icon: Icons.new_releases,
        //     //child: Text("Supposed to be here"),
        //     edgeInsets: EdgeInsets.only(right: 2.0, top: 8.0, bottom: 8.0)),
        buttonRoundAppBar(
            onPressed: () {},
            context: context,
            icon: Icons.shopping_bag_outlined,
            edgeInsets: EdgeInsets.only(right: 2.0, top: 8.0, bottom: 8.0)),
      ],
    );
  }

  Widget description({@required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("Category",
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                )),
                Text(
                  "GHS " + price.toString(),
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("Description",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18)),
                      //chekButonWaistsGroup(),
                    ],
                  ),
                ),
                //chekButonColorGroup(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(product_description,
                style: TextStyle(fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  // WIDGETS COMPONENTS
  Widget chekButonWaistsGroup() {
    Color colorAccent = Colors.pink.shade400;
    return Row(
      children: [
        MyCheckbox(
          onChanged: (s) => setState(() => positionWaist = 0),
          checkedFillColor: colorAccent,
          value: positionWaist == 0,
          checkedIcon: Text("S", style: TextStyle(color: Colors.white)),
          uncheckedIcon: Text("S", style: TextStyle(color: Colors.white)),
        ),
        MyCheckbox(
            onChanged: (s) => setState(() => positionWaist = 1),
            checkedFillColor: colorAccent,
            value: positionWaist == 1,
            checkedIcon: Text("M", style: TextStyle(color: Colors.white)),
            uncheckedIcon: Text("M", style: TextStyle(color: Colors.white))),
        MyCheckbox(
          onChanged: (s) => setState(() => positionWaist = 2),
          checkedFillColor: colorAccent,
          value: positionWaist == 2,
          checkedIcon: Text("L", style: TextStyle(color: Colors.white)),
          uncheckedIcon: Text("L", style: TextStyle(color: Colors.white)),
        ),
        MyCheckbox(
          onChanged: (s) => setState(() => positionWaist = 3),
          checkedFillColor: colorAccent,
          value: positionWaist == 3,
          checkedIcon: Text("XL", style: TextStyle(color: Colors.white)),
          uncheckedIcon: Text("XL", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget chekButonColorGroup() {
    return Column(
      children: [
        Transform.scale(
            scale: positionColor == 1 ? 1.5 : 1.0,
            child: Radio(
                value: positionColor == 1 ? 1 : 0,
                groupValue: 1,
                activeColor: Colors.black,
                fillColor: MaterialStateProperty.all(Colors.black),
                onChanged: (s) => setState(() => positionColor = 1))),
        Transform.scale(
            scale: positionColor == 2 ? 1.5 : 1.0,
            child: Radio(
                value: positionColor == 2 ? 1 : 0,
                groupValue: 1,
                activeColor: Colors.purple,
                fillColor: MaterialStateProperty.all(Colors.purple),
                onChanged: (s) => setState(() => positionColor = 2))),
        Transform.scale(
            scale: positionColor == 3 ? 1.5 : 1.0,
            child: Radio(
                value: positionColor == 3 ? 1 : 0,
                groupValue: 1,
                activeColor: Colors.grey,
                fillColor: MaterialStateProperty.all(Colors.grey),
                onChanged: (s) => setState(() => positionColor = 3))),
      ],
    );
  }

  Widget button(
      {@required String text,
      Color colorText = Colors.white,
      Color colorButton = Colors.purple,
      double padding = 12}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20.0),
          onPrimary: Colors.white,
          primary: colorButton,
          shadowColor: colorButton,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: colorButton)),
          side: BorderSide(color: colorButton),
        ),
        child: Text("Iniciar sesión".toUpperCase(),
            style: TextStyle(
                color: colorText, fontSize: 18.0, fontWeight: FontWeight.bold)),
        onPressed: () {},
      ),
    );
  }

  Widget buttonRoundAppBar(
          {@required void Function() onPressed,
          @required BuildContext context,
          Widget child,
          @required IconData icon,
          @required EdgeInsets edgeInsets}) =>
      Material(
          color: Colors.transparent,
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Ink(
                      decoration: ShapeDecoration(
                          color: Brightness.dark == Theme.of(context).brightness
                              ? Colors.black
                              : Colors.white,
                          shape: CircleBorder()),
                      child: child == null
                          ? IconButton(
                              icon: Icon(icon),
                              color: Brightness.dark ==
                                      Theme.of(context).brightness
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: onPressed)
                          : child))));
}

// Checkbox personalizado
// Le podemos pasar cualquier widget como icono
class MyCheckbox extends StatefulWidget {
  final double size;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final Widget checkedIcon;
  final Color uncheckedIconColor;
  final Color uncheckedFillColor;
  final Widget uncheckedIcon;

  const MyCheckbox({
    this.size = 50,
    @required this.value,
    @required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = Colors.green,
    @required this.checkedIcon,
    this.uncheckedIconColor = Colors.white,
    this.uncheckedFillColor = Colors.grey,
    @required this.uncheckedIcon,
  });

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool _checked;
  CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(MyCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;

    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    Widget child;

    switch (_status) {
      case CheckStatus.empty:
        break;
      case CheckStatus.checked:
        child = widget.checkedIcon;
        break;
      case CheckStatus.unchecked:
        child = widget.uncheckedIcon;
        break;
    }

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color:
            widget.value ? widget.checkedFillColor : widget.uncheckedFillColor,
        border: Border.all(
            color: widget.value
                ? widget.checkedFillColor
                : widget.uncheckedFillColor,
            width: 0),
      ),
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0, top: 12.0),
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: _buildIcon(),
        onPressed: () => widget.onChanged(_checked),
      ),
    );
  }
}

enum CheckStatus { empty, checked, unchecked }
