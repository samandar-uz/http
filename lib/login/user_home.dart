import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Map<String, dynamic> userData = {};
  TextEditingController controller_1 = TextEditingController();

  bool isLoading = true;
  bool isLoadingImage = false;
  String? errorMessage;
  String result = "";

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        setState(() {
          errorMessage = 'Token topilmadi. Qayta login qiling.';
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse('https://dummyjson.com/auth/me');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          userData = Map<String, dynamic>.from(data);
          isLoading = false;
          errorMessage = null;
        });
      } else {
        if (!mounted) return;

        setState(() {
          errorMessage =
              'API xatosi: ${response.statusCode}. Qayta login qiling.';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Internet yoki server bilan bog‘lanishda xato.';
        isLoading = false;
      });
    }
  }

  Future<void> getImage(String text) async {
    setState(() {
      isLoadingImage = true;
    });
    final url = Uri.parse('https://prexzyapis.com/ai/genimage?prompt=$text');

    final response = await http.get(url);

    final data = jsonDecode(response.body);
    setState(() {
      isLoadingImage = false;
      result = data['image_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (router) => (false),
                          );

                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          getUsers();
                        },
                        child: const Text('Qayta urinish'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Center(
                      child: ClipOval(
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: Image.network(
                            userData['image']?.toString() ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return const Icon(Icons.account_circle, size: 70);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    profileRow('ID', userData['id']),
                    profileRow('Username', userData['username']),
                    profileRow(
                      'Name',
                      '${userData['firstName'] ?? ''} '
                          '${userData['lastName'] ?? ''}',
                    ),
                    profileRow('Email', userData['email']),
                    profileRow('Gender', userData['gender']),

                    const SizedBox(height: 30),

                    TextField(
                      controller: controller_1,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          getImage(controller_1.text.trim());
                        },
                        child: isLoadingImage
                            ? CircularProgressIndicator()
                            : Text(
                                'Yaratish',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Image.network(result),
                  ],
                ),
        ),
      ),
    );
  }

  Widget profileRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title:'),
          Flexible(
            child: Text(value?.toString() ?? '-', textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
