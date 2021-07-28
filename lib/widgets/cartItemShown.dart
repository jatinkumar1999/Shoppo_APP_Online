import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoppo/providers/cart.dart';

class CartItemShown extends StatelessWidget {
  final String id;
  final String prodid;
  final String title;
  final double price;
  final double quantity;
  const CartItemShown({
    Key? key,
    required this.id,
    required this.prodid,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //!show Dialogue
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 5),
                    Text("WARNING", style: TextStyle(color: Colors.red)),
                  ]),
                  content: Text("Are you really want to delete the Cart item ?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("NO")),
                    TextButton(
                        onPressed: () {
                          cart.removeItemFormCart(prodid);
                          Navigator.of(context).pop(true);
                        },
                        child: Text("YES")),
                  ],
                ));
      },
      onDismissed: (direction) {
        print("delete $id");
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(title),
          leading: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            height: 50,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: Theme.of(context).accentColor,
              width: 3,
            )),
            child: Text("\$$price"),
          ),
          subtitle: Text("\$${price * quantity}"),
          trailing: Text("${quantity}x"),
        ),
      ),
    );
  }
}
