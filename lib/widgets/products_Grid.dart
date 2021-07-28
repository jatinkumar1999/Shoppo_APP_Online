import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/cart.dart';

import 'package:shoppo/providers/products.dart';
import 'package:shoppo/providers/products_Provider.dart';
import 'package:shoppo/widgets/products_item_show_tile.dart';

class ProductsGrid extends StatelessWidget {
  final bool showisFavourate;
  const ProductsGrid(
    this.showisFavourate,
  );

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
  
    final products =
        showisFavourate ? productsData.showonlyFavourate : productsData.list;
    return GridView.builder(
      padding: EdgeInsets.all(12.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) { 
        return ChangeNotifierProvider.value(
          value: products[index],
          child:  ProductsItemsShowtile(
              // id: prod.id,
              // title: prod.title,
              // description: prod.description,
              // imageUrl: prod.imageUrl,

              ),
        );
      },
    );
  }
}
