import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/product_model.dart';


class ApiService {
  static const String url = 'https://dummyjson.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(jsonDecode(response.body));
      final List<Product> products = (data['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList();
      print("products");
      return products;
    } else {
      print('Failed to load products: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }
}
