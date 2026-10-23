import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:https_project/detilsPage.dart';

import 'model/categoryModel.dart';
import 'model/productModel.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  List<Product> products = [];
  List<Categorys> categories = [];
  String buttonName = "all";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProduct();
    getCategory();
  }

  Future<void> getProduct() async {
    final url = Uri.parse("https://dummyjson.com/products");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final product = Pokedex.fromJson(data);

      if (!mounted) return;

      setState(() {
        products = product.products;
      });
    }
  }

  Future<void> getCategory() async {
    final url = Uri.parse("https://dummyjson.com/products/categories");
    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final categoryList = data.map((item) {
      return Categorys.fromJson(item);
    }).toList();

    setState(() {
      categories = categoryList;
    });
  }

  Future<void> getProductByCategory(String slug) async {
    setState(() {
      buttonName = slug;
    });

    final url = Uri.parse(
      slug == 'all'
          ? "https://dummyjson.com/products"
          : "https://dummyjson.com/products/category/$slug",
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);
    final product = Pokedex.fromJson(data);

    if (!mounted) return;

    setState(() {
      products = product.products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        title: const Text(
          "Mahsulotlar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade100,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonName == "all"
                              ? Colors.black
                              : Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          getProductByCategory('all');
                        },
                        child: Text(
                          "Barchasi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonName == category.slug
                                ? Colors.black
                                : Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {
                            getProductByCategory(category.slug);
                          },
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 30),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                    ? const Center(child: Text('Mahsulot topilmadi'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Detilspage(product: products[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                width: 120,
                                                child: Image.network(
                                                  products[index].thumbnail,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  products[index].title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                Text(
                                                  products[index].description,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                products[index].price
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Icon(
                                                Icons.attach_money,
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Qoldi: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                products[index].stock
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
