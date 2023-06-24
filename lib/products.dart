import 'dart:convert';
import 'dart:js_interop';

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

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://app1-7d097-default-rtdb.firebaseio.com/product.json');
    try {
      final http.Response res = await http.get(url);
      final Map<String, dynamic> extractedData =
          json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        var isExist = productsList.firstWhere(
          (element) => element.id == prodId,
          orElse: () => Product(
            id: '',
            title: '',
            description: '',
            price: 0.0,
            imageUrl: '',
          ),
        );
        if (isExist.isNull) {
          productsList.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ));
        }
      });

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  // Future<void> fetchData() async {
  //   final url = Uri.parse(
  //       'https://app1-7d097-default-rtdb.firebaseio.com/product.json');
  //   try {
  //     final http.Response res = await http.get(url);
  //     final extractedData = json.decode(res.body) as Map<String, dynamic>;
  //     extractedData.forEach((prodId, prodData) {
  //       final prodIndex =
  //           productsList.indexWhere((element) => element.id == prodId);
  //       if (prodIndex >= 0) {
  //         productsList[prodIndex] = Product(
  //           id: prodId,
  //           title: prodData['title'],
  //           description: prodData['description'],
  //           price: prodData['price'],
  //           imageUrl: prodData['imageUrl'],
  //         );
  //       } else {
  //         productsList.add(Product(
  //           id: prodId,
  //           title: prodData['title'],
  //           description: prodData['description'],
  //           price: prodData['price'],
  //           imageUrl: prodData['imageUrl'],
  //         ));
  //       }
  //     });

  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<void> add({
    required String id,
    required String title,
    required String description,
    required double price,
    required String imageUrl,
  }) async {
    try {
      final url = Uri.parse(
          'https://app1-7d097-default-rtdb.firebaseio.com/product.json');
      var res = await http.post(url,
          body: json.encode({
            'id': id,
            'title': title,
            'description': description,
            'price': price,
            'imageUrl': imageUrl,
          }));

      productsList.add(Product(
          id: json.decode(res.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateData(String id) async {
    final url =
        Uri.parse('https://app1-7d097-default-rtdb.firebaseio.com/$id.json');

    final prodIndex = productsList.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            "title": "new title 4",
            "description": "new description 2",
            "price": 199.8,
            "imageUrl":
                "https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg",
          }));

      productsList[prodIndex] = Product(
        id: id,
        title: "new title 4",
        description: "new description 2",
        price: 199.8,
        imageUrl:
            "https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg",
      );

      notifyListeners();
    } else {
      print("...");
    }
  }

  void delete(String id) {
    productsList.removeWhere((element) => element.id == id);
    notifyListeners();
    print('Item deleted successfully');
  }
}
