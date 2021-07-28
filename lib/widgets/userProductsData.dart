import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/pages/edit_Products.dart';

import 'package:shoppo/pages/edit_product_screen.dart';
import 'package:shoppo/providers/products_Provider.dart';

class UserProductsData extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  const UserProductsData({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProducts.routeName, arguments: id);

                    print(id);
                  },
                  icon:
                      Icon(Icons.edit, color: Theme.of(context).primaryColor)),
              IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .removesingleProduct(id);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                          duration:Duration(milliseconds: 600),
                            content: Text("Unable To delete the product"),
                            
                            
                            ));
                    }
                  },
                  icon:
                      Icon(Icons.delete, color: Theme.of(context).errorColor)),
            ],
          ),
        ),
      ),
    );
  }
}
