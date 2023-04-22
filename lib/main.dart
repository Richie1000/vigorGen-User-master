import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/add_attendance_screen.dart';
import 'package:flutter_complete_guide/screens/attendance_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/add_product_screen.dart';
import './screens/auth_screen.dart';
import 'widgets/loading_screen.dart';
import './helpers/custom_route.dart';
import './screens/lab_services_screen.dart';
import './providers/labtest.dart';
import 'screens/add_lab_service.dart';
import 'screens/manage_labs_screen.dart';
import 'screens/edit_labs_screen.dart';
import 'providers/lab_cart.dart';
import 'screens/lab_cart_screen.dart';
import 'screens/lab_request_details_screen.dart';
import './screens/checkout_screen.dart';
import './screens/chatbot_screen.dart';
import './screens/splash_screen.dart';
import  './screens/add_attendance_screen.dart';

const MaterialColor kPrimaryColor = const MaterialColor(
  0xFFEF9A9A,
  const <int, Color>{
    50: const Color(0xFFEF9A9A),
    100: const Color(0xFFEF9A9A),
    200: const Color(0xFFEF9A9A),
    300: const Color(0xFFEF9A9A),
    400: const Color(0xFFEF9A9A),
    500: const Color(0xFFEF9A9A),
    600: const Color(0xFFEF9A9A),
    700: const Color(0xFFEF9A9A),
    800: const Color(0xFFEF9A9A),
    900: const Color(0xFFEF9A9A),
  },
);
bool showSplash = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool showSplashScreen() {
    if (showSplash) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(value: LabTest()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(value: LabCart()),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MEK Pharmacy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: kPrimaryColor,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                    
                    ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.purple),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              })),
          home: auth.isAuth
              ? MyCustomSplashScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen()),
          routes: {
            "/overview": (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            LabScreen.routeName: (ctx) => LabScreen(),
            AddLabService.routeName: (ctx) => AddLabService(),
            ManageLabs.routeName: (ctx) => ManageLabs(),
            EditLabsScreen.routeName: (ctx) => EditLabsScreen(),
            LabCartScreen.routeName: (ctx) => LabCartScreen(),
            LabRequestDetailsScreen.routeName: (ctx) =>
                LabRequestDetailsScreen(),
            CheckOutScreen.routeName: (ctx) => CheckOutScreen(),
            ChatBotScreen.routeName: (ctx) => ChatBotScreen(),
            AttendanceScreen.routeName:(context) => AttendanceScreen(),
            AddAttendancePage.routeName:(context) => AddAttendancePage(),
          },
        ),
      ),
    );
  }
}
