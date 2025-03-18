import 'package:http/http.dart' as http;

class ProductService {
  static Future<http.Response> getAllProducts() {
    return http.get(Uri.parse('http://localhost:3000/api/products/list'));
  }

  static Future<http.Response> getProductById(String productId) {
    return http.get(Uri.parse('http://localhost:3000/api/products/\$productId'));
  }

  static Future<http.Response> createProduct(Map<String, String> data, String token) {
    return http.post(
      Uri.parse('http://localhost:3000/api/products/create'),
      headers: {'Authorization': 'Bearer \$token'},
      body: data,
    );
  }
}
