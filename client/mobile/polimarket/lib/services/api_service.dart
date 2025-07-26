import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polimarket/Models/Product.dart';
import 'package:polimarket/Models/Supplier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://666f6zf0-5242.use2.devtunnels.ms/api'; 
  // final String baseUrl = 'http://10.0.2.2:5242/api'; 
  // final String baseUrl = 'http://localhost:5242/api'; 

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Product>> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/sales/products');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener datos');
    }
  }

  Future<bool> addProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/warehouse/products');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


    Future<bool> addSupplier(Supplier supplier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/suppliers/suppliers');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

    Future<List<Supplier>> getSuppliers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/suppliers/suppliers');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Supplier.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener datos');
    }
  }
}
