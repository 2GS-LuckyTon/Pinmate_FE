import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  // Function to login and retrieve user ID from a separate endpoint
  Future<String?> login(String email, String password) async {
    final loginUrl = Uri.parse('$baseUrl/api/user/login');

    try {
      final loginResponse = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (loginResponse.statusCode == 200) {
        // Login successful, but user ID is not available in the response or from any endpoint

        // Temporarily store email as identifier
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        return email; // Placeholder identifier if ID is unavailable
      } else {
        print('Login failed with status: ${loginResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  // Other functions remain unchanged
  Future<Map<String, dynamic>?> signup(String email, String password, String image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final url = Uri.parse('$baseUrl/api/user/join');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'image': image,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Signup failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Signup Exception: $e');
      return null;
    }
  }
}