import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoppo/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItems {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;
  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItems> _order = [];

  List<OrderItems> get order {
    return [..._order];
  }

  Future<void> ftechAnssetOrders() async {
    try {
      final url =
          "https://messenger-clone-1b795-default-rtdb.firebaseio.com/orders.json";
      final result = await http.get(Uri.parse(url));
      print(json.decode(result.body));

      List<OrderItems> loadData = [];
      final extrasData = json.decode(result.body) as Map<String, dynamic>;

      // ignore: unnecessary_null_comparison
      if (extrasData == null) {
        return;
      }
      extrasData.forEach((orderId, orderData) {
        loadData.add(
          OrderItems(
              id: orderId,
              amount: orderData["amount"],
              products: (orderData["products"] as List<dynamic>)
                  .map((cd) => CartItems(
                        id: cd["id"],
                        title: cd["title"],
                        quantity: cd["quantity"],
                        price: cd["price"],
                      ))
                  .toList(),
              dateTime: DateTime.parse(orderData["dateTime"])),
        );
      });

      _order = loadData;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> orderTheItems(List<CartItems> cartProducts, double total) async {
    final url =
        "https://messenger-clone-1b795-default-rtdb.firebaseio.com/orders.json";
    final datetime = DateTime.now();
    final result = await http.post(Uri.parse(url),
        body: json.encode({
          "amount": total,
          "dateTime": datetime.toIso8601String(),
          "products": cartProducts
              .map((cd) => {
                    "id": cd.id,
                    "price": cd.price,
                    "quantity": cd.quantity,
                    "title": cd.title,
                  })
              .toList(),
        }));

    _order.insert(
      0,
      OrderItems(
        id: json.decode(result.body)["name"],
        amount: total,
        products: cartProducts,
        dateTime: datetime,
      ),
    );
    notifyListeners();
  }
}
