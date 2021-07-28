import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/products_Provider.dart';
import 'package:shoppo/widgets/app_Drawer.dart';
import 'package:shoppo/widgets/userProductsData.dart';

import 'edit_Products.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/product";
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context,listen:false).fetchDataAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context);
    final list = prod.list;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Procucts"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProducts.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshData(context),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final data = list[index];

            return UserProductsData(
              id: data.id,
              imageUrl: data.imageUrl,
              title: data.title,
            );
          },
        ),
      ),
    );
  }
}
