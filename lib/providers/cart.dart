import 'package:flutter/material.dart';

class CartItems {
  final String id;
  final String title;
  final double quantity;
  final double price;
  CartItems({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _cartItems = {};

  Map<String, CartItems> get cartItem {
    return {..._cartItems};
  }

  int cartLength() {
    return _cartItems.length;
  }

  double get totalPrice {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  removeSingleItemFromCart(String id) {
    if (!_cartItems.containsKey(id)) return;
    if (_cartItems[id]!.quantity > 1) {
      _cartItems.update(
        id,
        (existingData) => CartItems(
          id: existingData.id,
          title: existingData.title,
          quantity: existingData.quantity - 1,
          price: existingData.price,
        ),
      );
    } else {
      _cartItems.remove(id);
    }
    notifyListeners();
  }

  addtoCart(String id, String title, double price) {
    if (_cartItems.containsKey(id)) {
      _cartItems.update(
          id,
          (existingItem) => CartItems(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
                price: existingItem.price,
              ));
    } else {
      _cartItems.putIfAbsent(
        id,
        () => CartItems(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  removeItemFormCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
