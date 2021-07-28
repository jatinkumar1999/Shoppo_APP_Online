import 'package:flutter/material.dart';
import 'package:shoppo/pages/ordersScreens.dart';
import 'package:shoppo/pages/products_overview_screen.dart';
import 'package:shoppo/pages/userProductsScreen.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text("Hello Freiends !")),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context,
                  ProductsOverviewScreen.routeName
                 );
            },
            
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreens.routeName);
            },
          ),
            Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
