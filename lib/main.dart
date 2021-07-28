import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/pages/auth_Screen.dart';
import 'package:shoppo/pages/edit_Products.dart';
import 'package:shoppo/pages/products_details_screens.dart';
import 'package:shoppo/pages/products_overview_screen.dart';
import 'package:shoppo/pages/userProductsScreen.dart';
import 'package:shoppo/providers/auth.dart';
import 'package:shoppo/providers/cart.dart';
import 'package:shoppo/providers/order.dart';
import 'package:shoppo/providers/products_Provider.dart';
import 'package:shoppo/routes/custom_page_routes.dart';
import 'pages/cartScreen.dart';

import 'pages/ordersScreens.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopoo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrange,
            canvasColor: Colors.brown[50],
            fontFamily: "Lato",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              // TargetPlatform.android: CustomRouteTransiaction(),
              TargetPlatform.windows :CustomRouteTransiaction(),
            }),
          ),
          home: ProductsOverviewScreen(),
          routes: {
            // AuthScreen.routeName: (context) => AuthScreen(),
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen(),
            ProductsDetailsScreens.routeName: (context) =>
                ProductsDetailsScreens(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreens.routeName: (context) => OrdersScreens(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProducts.routeName: (context) => EditProducts(),
          },
        ),
      ),
    );
  }
}
