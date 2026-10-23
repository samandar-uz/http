import 'package:flutter/material.dart';
import 'package:https_project/model/productModel.dart';

class Detilspage extends StatelessWidget {
  final Product product;

  const Detilspage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade100,
        title: Text(
          "Mahsulot haqida",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ...product.images.map((image) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Image.network(
                        image,
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ],
              ),
            ),

            Text(product.brand.toString(), style: TextStyle(fontSize: 50)),
            Text("Comments:", style: TextStyle(fontSize: 40)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    ...product.reviews.map((image) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  image.comment,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(image.reviewerName),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
