import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourate;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourate = false,
  });

  toggleisFavourateStatus() {
    final url =
        "https://messenger-clone-1b795-default-rtdb.firebaseio.com/products/$id.json";
    final existingIsFavourate = isFavourate;
    isFavourate = !isFavourate;
    notifyListeners();
    http
        .patch(Uri.parse(url),
            body: json.encode(
              {
                "isFavourate": isFavourate,
              },
            ))
        .then((result) {
          if(result.statusCode>=400){
            isFavourate = existingIsFavourate;
      notifyListeners();
          }
        })
        .catchError((e) {
      isFavourate = existingIsFavourate;
      notifyListeners();
    });
  }
}
