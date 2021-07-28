import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoppo/modal/httpException.dart';
import 'products.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // final String token;
  // Products(this.token);

  List<Product> get list {
    return [
      ..._list,
    ];
  }

  List<Product> get showonlyFavourate {
    return _list.where((prod) => prod.isFavourate).toList();
  }

  Product findById(String id) {
    return _list.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchDataAndSet() async {
    try {
      const url =
          "https://messenger-clone-1b795-default-rtdb.firebaseio.com/products.json";
      final response = await http.get(Uri.parse(url));
      final List<Product> loadData = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      data.forEach((prodId, prodData) {
        loadData.add(Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            imageUrl: prodData["imageUrl"],
            isFavourate: prodData["isFavourate"]));
      });
      _list = loadData;
      notifyListeners();

      print(data);
    } catch (e) {
      return;
    }
  }

  Future<void> addProducts(Product product) async {
    const url =
        "https://messenger-clone-1b795-default-rtdb.firebaseio.com/products.json";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavourate": product.isFavourate,
        }),
      );

      print(json.decode(response.body));

      final products = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(products);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void updateProducts(String id, Product product) {
    final productIndex = _list.indexWhere((prod) => prod.id == id);

    print(productIndex);
    if (productIndex >= 0) {
      _list[productIndex] = product;
    }
  }

  Future<void> removesingleProduct(String id) async {
    final url =
        "https://messenger-clone-1b795-default-rtdb.firebaseio.com/products/$id.json";

    final existprodIndex = _list.indexWhere((prod) => prod.id == id);
    var existingProduct = _list[existprodIndex];
    final result = await http.delete(Uri.parse(url));
    if (result.statusCode >= 400) {
      _list.insert(existprodIndex, existingProduct);
      notifyListeners();

      throw HttpException(message: "Couldn\'t delete the item");
    }
    // existingProduct = Product(
    //     id: "", title: "", description: "", price: 0, imageUrl: "");

    // _list.removeWhere((prod) => prod.id == id);
    _list.removeAt(existprodIndex);
    notifyListeners();
  }
}
