import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/products.dart';

import '../providers/products_Provider.dart';

class ProductsDetailsScreens extends StatelessWidget {
  static const routeName = "/detail";

  // final Product prod;
  // const ProductsDetailsScreens({
  //   Key? key,
  //   required this.prod,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context,)!.settings.arguments as String;
    final prod = Provider.of<Products>(context,listen: false).findById(prodId);
    return Scaffold(
      appBar: AppBar(
        title: Text(prod.title),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag:prod.imageUrl,
                child: Image.network(
                  prod.imageUrl,
                  fit: BoxFit.cover,
                ),
              )),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(prod.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Text("\$${prod.price}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        
            Text(prod.description),
        
        ],
      ),
    );
  }
}
