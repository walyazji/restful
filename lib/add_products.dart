import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String title = "";
  String description = "";
  String price = "";
  String imageUrl = "";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Title", hintText: "Add title"),
                    onChanged: (val) => setState(() => title = val),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Description", hintText: "Add description"),
                    onChanged: (val) => setState(() => description = val),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Price", hintText: "Add price"),
                    onChanged: (val) => setState(() => price = val),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Image Url",
                        hintText: "Paste your image url here"),
                    onChanged: (val) => setState(() => imageUrl = val),
                  ),
                  const SizedBox(height: 30),
                  Consumer<Products>(
                    builder: (ctx, value, _) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            textStyle: const TextStyle(color: Colors.black)),
                        child: const Text("Add Product"),
                        onPressed: () {
                          var doublePrice;
                          setState(() {
                            doublePrice = double.tryParse(price) ?? 0.0;
                          });

                          if (title == "" ||
                              description == "" ||
                              price == "" ||
                              imageUrl == "") {
                            Fluttertoast.showToast(
                              msg: 'Please enter all field',
                              toastLength: Toast.LENGTH_LONG,
                            );
                          } else if (doublePrice == 0.0) {
                            Fluttertoast.showToast(
                              msg: 'Please enter a valid price',
                              toastLength: Toast.LENGTH_LONG,
                            );
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            value
                                .add(
                              id: DateTime.now().toString(),
                              title: title,
                              description: description,
                              price: doublePrice,
                              imageUrl: imageUrl,
                            )
                                .catchError((_) {
                              return showDialog<void>(
                                context: context,
                                builder: (innerContext) => AlertDialog(
                                  title: const Text("An error occurred!"),
                                  content: const Text('Something went wrong.'),
                                  actions: [
                                    TextButton(
                                        child: const Text("Okay"),
                                        onPressed: () =>
                                            Navigator.of(innerContext).pop())
                                  ],
                                ),
                              );
                            }).then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pop(context);
                            });
                          }
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
