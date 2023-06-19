import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Products with ChangeNotifier {
  List<Product> productsList = [];
  Future<void> add(
      {required String id,
      required String title,
      required String description,
      required double price,
      required String imageUrl}) async {
    final url = Uri.parse(
        'https://app1-7d097-default-rtdb.firebaseio.com/product.json');
    return http
        .post(url,
            body: json.encode({
              'id': id,
              'title': title,
              'description': description,
              'price': price,
              'imageUrl': imageUrl,
            }))
        .then((res) {
      productsList.add(Product(
          id: json.decode(res.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl));
      notifyListeners();
    });
  }

  void delete(String id) {
    productsList.removeWhere((element) => element.id == id);
    notifyListeners();
    print('Item deleted successfully');
  }
}
