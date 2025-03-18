import 'package:http/http.dart' as http;

class StockService {
  static Future<http.Response> createStock(Map<String, String> data, String token) {
    return http.post(
      Uri.parse('http://localhost:3000/api/stocks/create'),
      headers: {'Authorization': 'Bearer \$token'},
      body: data,
    );
  }

  static Future<http.Response> getStockByProduct(String productId) {
    return http.get(Uri.parse('http://localhost:3000/api/stocks/by-product/\$productId'));
  }
}
