/// Copyright 2020 Logica Booleana Authors

// ignore_for_file: meta_language_version

// Dependencias de Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Dependencias de la app
//...
/// Dependencias de https://pub.dev/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

// objeto de la clase
class Product {
  String imageUrl;
  String description;
  int price;
  bool isFull;
  bool hasFreeShipping;

  Product({
    @required this.imageUrl,
    @required this.description,
    @required this.price,
    this.isFull = false,
    this.hasFreeShipping = false,
  });
}

// data source
List<Product> productList = [
  Product(
      imageUrl:
          "https://www.tiomusa.com.ar/imagenes/archivos/2020-04/25498-auricularbluetoothf2.jpg",
      description:
          "Auriculares inalámbricos con micrófono integrado y cancelación de ruido",
      price: 100,
      isFull: true,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://importadoracentral.com.ar/wp-content/uploads/2021/10/D20-VR-550x550.jpg",
      description:
          "Smartwatch con pantalla táctil y monitor de actividad física",
      price: 150,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://m.media-amazon.com/images/I/414iWlQrjlL._AC_SS450_.jpg",
      description:
          "Cámara de seguridad con detección de movimiento y visión nocturna",
      price: 80,
      hasFreeShipping: true),
  Product(
      imageUrl: "https://m.media-amazon.com/images/I/41O5OIMP42L.jpg",
      description:
          "Teclado mecánico para juegos con iluminación RGB y teclas programables",
      price: 120,
      isFull: true),
  Product(
      imageUrl:
          "https://www.soscomputacion.com.ar/23579-thickbox_default/tableta-grafica-digitalizadora-xp-pen-artist-12-pro-windows-mac-display.jpg",
      description:
          "Tableta gráfica para dibujar y diseñar con lápiz digital incluido",
      price: 200,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://app.contabilium.com/files/explorer/16752/Productos-Servicios/concepto-4876433.jpg",
      description: "Disco duro externo de 2TB con conexión USB 3.0",
      price: 80,
      hasFreeShipping: true),
  Product(
      imageUrl: "https://i.blogs.es/8afc08/nesti/450_1000.jpg",
      description:
          "Altavoz inteligente con asistente virtual integrado y conexión Bluetooth",
      price: 90,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://www.lg.com/es/images/monitores/md07517443/gallery/24GN600_3.jpg",
      description:
          "Monitor gaming de 27 pulgadas con resolución 4K y frecuencia de actualización de 144Hz",
      price: 500,
      isFull: true,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://www.atajo.com.ar/images/0000000000Z4B04A47499Z4B04A.jpg",
      description:
          "Impresora multifunción con conexión Wi-Fi y escáner de alta resolución",
      price: 150,
      hasFreeShipping: true),
  Product(
      imageUrl:
          "https://ae01.alicdn.com/kf/Sf50511eda70a4e008170335065928557m.jpg",
      description:
          "Ratón inalámbrico con sensor óptico de alta precisión y diseño ergonómico",
      price: 50,
      hasFreeShipping: true)
];

// ignore: must_be_immutable
class NewOverview extends StatelessWidget {
  static const routeName = '/newOverview';
  NewOverview({Key key}) : super(key: key);

  // var
  Size screenSize;
  Color backgroundColor = Colors.yellow.shade500;
  Color backgroundColor2 = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    // var
    screenSize = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData.light(), // El tema es claro por defecto
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: appbar(),
        body: body(),
        drawer: const Drawer(),
      ),
    );
  }

  // WIDGETS VIEWS
  PreferredSizeWidget appbar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      toolbarHeight: 90.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: Colors.grey[800]),
      titleSpacing: 0.0,
      title: buttonBuscador(),
      actions: const [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.black54,
          ),
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
          child: Row(
            children: const [
              Icon(Icons.location_on_outlined,
                  size: 14.0, color: Colors.black87),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text("Enviar a Lucas - Capital Federal",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400)),
              ),
              Icon(Icons.arrow_forward_ios, size: 12.0, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      color: backgroundColor2,
      child: ListView(
        children: [
          // view : carrusel de tarjetas con imagenes de publicidad
          horizontalCardsView(),
          // view : botons de suscripcion
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
            child: buttonSubcriptionWidget(),
          ),
          // view : tarjetas de publicidad
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
            child: publicityAdvertisingCard(),
          ),
          // Lista horizontal de botones de categorias
          const ListButtonsHorizontal(),
          // view : tarjetas de publicidad
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: publicityCard(),
          ),
          // view : lista horizontal de productos recomendados segun el historial de busqueda
          RecomendedProductsListHorizonatal(),
          // view : lista vertical de productos recomendados segun el historial de busqueda
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: RecorProductsListVertical(),
          ),
          // button : boton de reembolso
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: reembolsoButton(),
          ),
          // button : boton de ayuda
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: aidButton(),
          ),
          // space
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget buttonSubcriptionWidget() {
    // descripcion : este widget es un boton con publicidad con un texto y un fondo gradient horizontalmente

    // style
    Decoration decoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.purple[600], Colors.deepPurple[800]]),
        borderRadius: BorderRadius.circular(5.0));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      width: screenSize.width,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Súbcribite al nivel 6 por \$ 699/mes",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white70, size: 14.0),
        ],
      ),
    );
  }

  Widget publicityAdvertisingCard() {
    // description : este es una tarjeta de publicidad

    // style
    Decoration decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1.0)]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      width: screenSize.width,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.local_shipping_outlined,
            color: Colors.green,
            size: 18.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              "Envio gratis",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
          Text(
            "en millones de productos desde \$8.000",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget publicityCard() {
    // description : este Card con una altura de 180 con la url de una imagen

    return Card(
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      color: Colors.grey.shade300,
      child: Container(
        height: 75,
        width: screenSize.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://marketplace.canva.com/EAFcK9MUgC8/2/0/1600w/canva-banner-fenix-ofertas-y-descuentos-moderno-azul-S1Gt0R3DLzM.jpg"),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget horizontalCardsView() {
    // descripcion : este widget es una lista horizontal de cards con publicidad

    // var
    double height = 160.0;
    // widgets
    List<Widget> widgetsCards = [
      cardPublicidad(
          url:
              "https://infogei.com/uploads/noticias/5/2020/07/20200729153013_hot-sale-mercado-libre.jpg"),
      cardPublicidad(
          url:
              "https://marketplace.canva.com/EAFcK9MUgC8/2/0/1600w/canva-banner-fenix-ofertas-y-descuentos-moderno-azul-S1Gt0R3DLzM.jpg"),
      cardPublicidad(
          url:
              "https://infosertecblog.files.wordpress.com/2019/02/190220-3.jpg"),
    ];
    // options carousel
    CarouselOptions carouselOptions = CarouselOptions(
      aspectRatio: 2.0,
      enlargeCenterPage: true,
      enlargeStrategy: CenterPageEnlargeStrategy.height,
      viewportFraction: 0.93,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 5),
      autoPlayAnimationDuration: const Duration(milliseconds: 300),
      autoPlayCurve: Curves.fastOutSlowIn,
      scrollDirection: Axis.horizontal,
    );

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [backgroundColor, Colors.grey[100]],
                stops: const [0.3, 0.8],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter)),
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        width: double.infinity,
        height: height,
        child: CarouselSlider.builder(
          itemCount: widgetsCards.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
              widgetsCards[index],
          options: carouselOptions,
        ));
  }

  /// WIDGETS COMPONENTS
  Widget buttonBuscador() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 16.0,
        ),
        label: const Text("Busca en Mercado Livre",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)))),
      ),
    );
  }

  Widget cardPublicidad({@required String url}) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            width: screenSize.width * 0.90,
            height: 100.0,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 200),
                fit: BoxFit.cover,
                imageUrl: url,
                placeholder: (context, urlImage) =>
                    Container(color: Colors.grey),
                errorWidget: (context, urlImage, error) =>
                    Center(child: Container(color: Colors.grey))),
          ),
        ),
      ),
    );
  }

  Widget reembolsoButton() {
    // description : botton de reembolso
    return Card(
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
        onTap: () {},
        leading:
            const Icon(Icons.refresh_rounded, color: Colors.blue, size: 24.0),
        title: const Text("Botón de reebolso",
            style: TextStyle(color: Colors.black, fontSize: 14.0)),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 14.0),
      ),
    );
  }

  Widget aidButton() {
    // description : botton de ayuda
    return Card(
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
        onTap: () {},
        leading:
            const Icon(Icons.email_outlined, color: Colors.blue, size: 24.0),
        title: const Text("ayuda@mercadolivre.com",
            style: TextStyle(color: Colors.black, fontSize: 14.0)),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 14.0),
      ),
    );
  }
}

// CLASS VIEWS
class ListButtonsHorizontal extends StatelessWidget {
  const ListButtonsHorizontal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      height: 95.0,
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          buttonCircle(icon: Icons.local_offer_rounded, texto: "Ofertas"),
          buttonCircle(icon: Icons.workspace_premium, texto: "Cupones"),
          buttonCircle(icon: Icons.shopping_basket_rounded, texto: "Súper"),
          buttonCircle(icon: Icons.phone_iphone_rounded, texto: "Celular"),
          buttonCircle(icon: Icons.wc, texto: "Moda"),
          buttonCircle(icon: Icons.add, texto: "ver más"),
        ],
      ),
    );
  }

  Widget buttonCircle({@required String texto, @required IconData icon}) {
    // var
    double sizeIcon = 25.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Material(
          elevation: 1, //Elevación del círculo
          shape: const CircleBorder(), //Borde circular del material
          child: CircleAvatar(
            backgroundColor: Colors.white, //Color de fondo del círculo
            radius: sizeIcon, //Tamaño del círculo
            child: Icon(icon,
                color: Colors.black45,
                size: sizeIcon), //Icono en el centro del círculo
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
                width: 70.0,
                child: Text(texto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black45, fontSize: 10.0)))),
      ],
    );
  }
}

class RecomendedProductsListHorizonatal extends StatelessWidget {
  RecomendedProductsListHorizonatal();

  // description : creamos una lista de productos horizontal con 'CardOfertas'

  // widgets
  final List<Widget> widgets = [
    const SizedBox(width: 12),
    CardOfertas(
        title: "Oferta temporal",
        envioGratis: true,
        full: true,
        url: productList[4].imageUrl,
        descripcion: productList[4].description,
        precio: productList[4].price),
    CardOfertas(
        title: "Visto recientemente",
        full: false,
        envioGratis: true,
        url: productList[5].imageUrl,
        descripcion: productList[5].description,
        precio: productList[5].price),
    CardOfertas(
        title: "Oferta del día",
        full: true,
        url: productList[6].imageUrl,
        descripcion: productList[6].description,
        precio: productList[6].price),
    CardOfertas(
        title: "Lleva tu favorito!",
        full: false,
        envioGratis: true,
        url: productList[7].imageUrl,
        descripcion: productList[7].description,
        precio: productList[7].price),
    CardOfertas(
        title: "Envio gratis",
        full: false,
        url: productList[8].imageUrl,
        descripcion: productList[8].description,
        precio: productList[8].price),
    CardOfertas(
        title: "Más vendido",
        full: false,
        url: productList[9].imageUrl,
        descripcion: productList[9].description,
        precio: productList[9].price),
  ];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return SizedBox(
      height: 215,
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }
}

class RecorProductsListVertical extends StatelessWidget {
  const RecorProductsListVertical();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Según tu historial de navegación',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            ),
            const Divider(height: 0.0),
            // lista de productos
            Expanded(
              child: Column(
                children: [
                  itemListTile(
                      url: productList[0].imageUrl,
                      description: productList[0].description,
                      precio: productList[0].price,
                      envioGratis: productList[0].hasFreeShipping),
                  itemListTile(
                      url: productList[1].imageUrl,
                      description: productList[1].description,
                      precio: productList[1].price,
                      envioGratis: productList[1].hasFreeShipping),
                  itemListTile(
                      url: productList[2].imageUrl,
                      description: productList[2].description,
                      precio: productList[2].price,
                      envioGratis: productList[2].hasFreeShipping),
                  itemListTile(
                      url: productList[3].imageUrl,
                      description: productList[3].description,
                      precio: productList[3].price,
                      envioGratis: productList[3].hasFreeShipping),
                ],
              ),
            ),
            const Divider(height: 0.0),
            // button
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              onTap: () {},
              title: const Text("Ver más",
                  style: TextStyle(color: Colors.blue, fontSize: 14.0)),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.blue, size: 14.0),
            )
          ],
        ),
      ),
    );
  }

  // widgets componentst
  Widget itemListTile(
      {@required String url,
      @required String description,
      @required int precio,
      @required bool envioGratis}) {
    // description : un 'ListTile' con una imagen,un titulo,el precio y un texto que diga 'Envio Gratis' de color verde
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      onTap: () {},
      leading: AspectRatio(
        aspectRatio: 100 / 75,
        child: url != ""
            ? CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 200),
                fit: BoxFit.contain,
                imageUrl: url,
                placeholder: (context, urlImage) => const FadeInImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/loading.gif"),
                    placeholder: AssetImage("assets/loading.gif")),
                errorWidget: (context, urlImage, error) =>
                    Center(child: Container(color: Colors.grey)),
              )
            : Container(color: Colors.black26),
      ),
      title: Text(description, style: const TextStyle(fontSize: 12.0)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text("\$ $precio",
                style: const TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          envioGratis
              ? const Text("Envio Gratis",
                  style: TextStyle(fontSize: 12.0, color: Colors.green))
              : const SizedBox()
        ],
      ),
    );
  }
}

// CLASS COMPONENTS
class CardOfertas extends StatelessWidget {
  const CardOfertas(
      {this.title = "",
      this.descripcion = "",
      this.url = "",
      this.precio = 0,
      this.full = false,
      this.envioGratis = false});
  // var
  final bool envioGratis;
  final bool full;
  final String url;
  final String title;
  final String descripcion;
  final int precio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(3),
        color: Colors.white,
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // title
                  title != ""
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400)),
                        )
                      : Container(),
                  // divider
                  title != ""
                      ? Divider(color: Colors.grey[400], height: 1.0)
                      : Container(),
                  widgetImagenProducto(urlImage: url),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // text : descripcion
                        Text(descripcion,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600)),
                        const SizedBox(height: 3.0),
                        // text : precio
                        Text("\$ $precio",
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            envioGratis
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Text("Envío Gratis",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.green[600]),
                                        textAlign: TextAlign.start),
                                  )
                                : Container(),
                            full
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Row(children: [
                                      const Icon(Icons.flash_on,
                                          size: 12.0, color: Colors.green),
                                      Text("FULL",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.green.shade600,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic))
                                    ]))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Un widget imagen que intenta ajustar el tamaño del niño a una relación de aspecto específica
  Widget widgetImagenProducto({@required String urlImage}) {
    return AspectRatio(
      aspectRatio: 100 / 75,
      child: urlImage != ""
          ? CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 200),
              fit: BoxFit.contain,
              imageUrl: urlImage,
              placeholder: (context, urlImage) => const FadeInImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/loading.gif"),
                  placeholder: AssetImage("assets/loading.gif")),
              errorWidget: (context, urlImage, error) =>
                  Center(child: Container(color: Colors.grey)),
            )
          : Container(color: Colors.black26),
    );
  }
}
