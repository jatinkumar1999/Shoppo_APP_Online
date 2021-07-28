import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/cart.dart';
import 'package:shoppo/providers/products_Provider.dart';
import 'package:shoppo/widgets/app_Drawer.dart';
import 'package:shoppo/widgets/badge.dart';

import 'package:shoppo/widgets/products_Grid.dart';

import 'cartScreen.dart';

enum Filter {
  Favourate,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/home";
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showonlyFavourate = false;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchDataAndSet().then((_)  {
          setState(() {
        _isLoading = false;
      });
      });
    }
   
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading?Center(child:CircularProgressIndicator()):Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          title: Text("Shoppoo"),
          actions: [
            Consumer<Cart>(
              builder: (context, cart, ch) => Badge(
                  child: IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                    icon: Icon(Icons.shopping_cart),
                  ),
                  value: cart.cartLength().toString(),
                  color: Colors.red),
            ),
            PopupMenuButton(
                onSelected: (Filter selected) {
                  setState(() {
                    if (selected == Filter.Favourate) {
                      _showonlyFavourate = true;
                    } else {
                      _showonlyFavourate = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text("Favourate"),
                        value: Filter.Favourate,
                      ),
                      PopupMenuItem(
                        child: Text("Show All"),
                        value: Filter.All,
                      ),
                    ]),
          ],
        ),
        drawer: AppDrawer(),
        body: ProductsGrid(_showonlyFavourate));
  }
}
