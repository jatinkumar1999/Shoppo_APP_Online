import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/cart.dart';
import 'package:shoppo/providers/order.dart';
import 'package:shoppo/widgets/cartItemShown.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/card";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartitem = cart.cartItem;
    final order = Provider.of<Order>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Card(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total :",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        label: Text(
                          "\$${cart.totalPrice}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      OrderButton(cart: cart, order: order),
                    ]),
                SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                        itemCount: cartitem.values.toList().length,
                        itemBuilder: (context, index) {
                          final cart = cartitem.values.toList()[index];
                          final title = cart.title;
                          final id = cart.id;
                          final prodId = cartitem.keys.toList()[index];
                          final price = cart.price;
                          final quantity = cart.quantity;

                          print("sdnvdv ks msmclsmmcslmcscs;lcms  : $title");
                          // return Center(child: Text(price.toString()));
                          return CartItemShown(
                              id: id,
                              prodid: prodId,
                              title: title,
                              price: price,
                              quantity: quantity);
                        }))
              ],
            )),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.order,
  }) : super(key: key);

  final Cart cart;
  final Order order;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.order.orderTheItems(
                  widget.cart.cartItem.values.toList(), widget.cart.totalPrice);

              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
             
            },
      child: _isLoading?Center(child:CircularProgressIndicator()):Text("Order"),
    );
  }
}
