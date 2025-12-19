import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 192.168.137.1 for physical device connected to PC hotspot
  // Use 10.0.2.2 for Android Emulator
  static const String _baseUrl = 'http://192.168.137.1:3000';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$_baseUrl/data'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
