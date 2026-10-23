import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detils_page.dart';
import 'model/crypto_model.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  List<Crypto> cryptoList = [];
  bool isLoading = false;

  Future<void> fetchCrypto() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=1000&page=1",
    );
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    final cryptoLists = json.map((item) {
      return Crypto.fromJson(item);
    }).toList();
    setState(() {
      cryptoList = cryptoLists;
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchCrypto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "CryptoCheck",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              fetchCrypto();
            },
            icon: Icon(Icons.downloading, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: cryptoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetilsPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,

                              child: Image.network(cryptoList[index].image),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cryptoList[index].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cryptoList[index].symbol,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  cryptoList[index].currentPrice.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.attach_money),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
