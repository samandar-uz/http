import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse("https://ostonada.netdc.uz/api/mib/31205934567891");
  final response = await http.get(url);
  // ignore: avoid_print
  print(response.body);
}
