import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  List mib = [];
  String jamiQarz = "0";
  bool isQarz = false;
  bool isLoading = false;
  bool hasSearched = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getAPI(String jshshir) async {
    if (jshshir.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      hasSearched = true;
      mib.clear();
    });

    try {
      final url = Uri.parse("https://ostonada.netdc.uz/api/mib/$jshshir");
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      setState(() {
        mib = data['qarz_malumotlari'] ?? [];
        isQarz = data['qarzdorlik_mavjud'] ?? false;
        jamiQarz = data['jami_qarz']?.toString() ?? "0";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ma'lumot olishda xatolik yuz berdi"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "MIB Qarzni Tekshirish",
          style: GoogleFonts.interTight(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  style: GoogleFonts.interTight(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "JSHSHIR kiriting (14 ta raqam)",
                    hintStyle: GoogleFonts.interTight(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        top: 4,
                        bottom: 4,
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => getAPI(controller.text.trim()),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            CupertinoIcons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onSubmitted: (val) => getAPI(val.trim()),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (isLoading)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      )
                    else if (hasSearched) ...[
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: isQarz
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isQarz
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/pngegg.png",
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isQarz
                                    ? "Ey, sen shuncha ham qarz bo'lasanmi? Yoki yana kredit olib, to'lamadingmi?"
                                    : "Zo'r, qarzing yo'q ekanku!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.interTight(
                                  fontSize: 16,
                                  color: isQarz
                                      ? Colors.red.shade900
                                      : Colors.green.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isQarz) ...[
                                const SizedBox(height: 10),
                                Text(
                                  "Jami qarz: $jamiQarz so'm",
                                  style: GoogleFonts.interTight(
                                    fontSize: 22,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (mib.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = mib[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.doc_text_fill,
                                          color: Colors.blue.shade300,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['hujjat_mazmuni'] ??
                                                "Ma'lumot yo'q",
                                            style: GoogleFonts.interTight(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 24),
                                    _buildInfoRow(
                                      "Ijro raqami:",
                                      item['ijro_hujjati_raqami'],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      "Bo'lim nomi:",
                                      item['bolim_nomi'],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      "Miqdor:",
                                      "${item['qarz_summasi']} so'm",
                                      isAmount: true,
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      "Telefon:",
                                      item['bolim_telefoni'],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, childCount: mib.length),
                        ),
                    ] else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.search,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Qarzni tekshirish uchun\nJSHSHIR raqamini kiriting",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.interTight(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.interTight(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value?.toString() ?? "Noma'lum",
            textAlign: TextAlign.right,
            style: GoogleFonts.interTight(
              fontSize: 14,
              fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
              color: isAmount ? Colors.red : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
