// ignore_for_file: body_might_complete_normally_catch_error

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_products.dart';
import 'auth_screen.dart';
import 'product_details.dart';
import 'products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<Products>(
      create: (_) => Products(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange,
          canvasColor: const Color.fromRGBO(255, 238, 219, 1)),
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;

  //no use async await never but use then
  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchData()
        .then((_) => _isLoading = false)
        .catchError((onError) {
      print(onError as bool);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> prodList =
        Provider.of<Products>(context, listen: true).productsList;

    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (prodList.isEmpty
              ? const Center(
                  child: Text('No Products Added.',
                      style: TextStyle(fontSize: 22)))
              : RefreshIndicator(
                  onRefresh: () async =>
                      await Provider.of<Products>(context, listen: false)
                          .fetchData(),
                  child: ListView(
                    children: prodList
                        .map(
                          (item) => detailCard(item.id, item.title,
                              item.description, item.price, item.imageUrl),
                        )
                        .toList(),
                  ),
                )),
      floatingActionButton: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).primaryColor,
        ),
        child: TextButton.icon(
          label: const Text("Add Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          icon: const Icon(Icons.add),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddProduct())),
        ),
      ),
    );
  }

  Widget detailCard(id, tile, desc, price, imageUrl) {
    return Builder(
      builder: (innerContext) => TextButton(
        onPressed: () {
          print(id);
          Navigator.push(
            innerContext,
            MaterialPageRoute(builder: (_) => ProductDetails(id)),
          ).then(
              (id) => Provider.of<Products>(context, listen: false).delete(id));
        },
        child: Column(
          children: [
            const SizedBox(height: 5),
            Card(
              elevation: 10,
              color: const Color.fromRGBO(115, 138, 119, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: 130,
                      child: Hero(
                        tag: id,
                        child: Image.network(imageUrl, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Text(
                          tile,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.white),
                        Container(
                          width: 200,
                          child: Text(
                            desc,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                          ),
                        ),
                        const Divider(color: Colors.white),
                        Text(
                          "\$$price",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                  ),
                  const Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
