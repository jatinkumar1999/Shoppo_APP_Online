import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/pages/products_details_screens.dart';
import 'package:shoppo/providers/cart.dart';
import 'package:shoppo/providers/products.dart';
import 'package:shoppo/providers/products_Provider.dart';

class ProductsItemsShowtile extends StatelessWidget {
  // final String? id;
  // final String? title;
  // final String? imageUrl;
  // final String? description;
  // const ProductsItemsShowtile({
  //   Key? key,
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  //   this.description,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: GridTile(
          header: Text(prod.title),
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              ProductsDetailsScreens.routeName,
              arguments: prod.id,
            ),
            child: Hero(
              tag:prod.imageUrl,
              child: FadeInImage(
                placeholder: AssetImage("assets/images/product-placeholder.png"),
                image: NetworkImage(prod.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              onPressed: () {
                prod.toggleisFavourateStatus();
              },
              icon: Icon(prod.isFavourate
                  ? Icons.favorite
                  : Icons.favorite_outline_sharp),
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
                onPressed: () {
                  cart.addtoCart(prod.id, prod.title, prod.price);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Item Added to the Cart"),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            cart.removeSingleItemFromCart(prod.id);
                          }),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                )),
            title: Text(
              prod.description,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
