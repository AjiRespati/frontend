import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../application_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // ✅ Use this one!
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = ApplicationInfo.baseUrl;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  /// AUTH ROUTES
  /// /register'
  /// /login',
  /// /refresh',
  /// /logout',
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return true;
    }
    return false;
  }

  Future<bool> logout(String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"refreshToken": refreshToken}),
    );
    if (response.statusCode == 200) {
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return response.statusCode < 400;
  }

  Future<String?> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode < 400) {
      String newAccessToken = jsonDecode(response.body)['accessToken'];
      await prefs.setString('accessToken', newAccessToken);
      return newAccessToken;
    } else {
      return null;
    }
  }

  /// TODO: PRODUCTS ROUTES
  /// GET /
  /// POST /
  Future<List<dynamic>> fetchProducts() async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) return [];
      return fetchProducts();
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  // ✅ Create Product API with Image Upload
  Future<bool> createProduct(
    String name,
    String description,
    String metric,
    double price,
    Uint8List? imageWeb,
    XFile? imageDevice,
  ) async {
    String? token = await _getToken();
    var request = http.MultipartRequest("POST", Uri.parse('$baseUrl/products'));
    request.headers['Authorization'] = "Bearer $token";
    request.fields["name"] = name;
    request.fields["description"] = description;
    //TODO: ambil dari user JWT
    request.fields["updateBy"] = "ambil dari user";
    request.fields["price"] = price.toString();
    request.fields["metricType"] = metric; // ✅ Add metric field

    // ✅ Handle Web (File Picker)
    if (kIsWeb && imageWeb != null) {
      Uint8List imageBytes = imageWeb;
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: "product_image.png",
          contentType: MediaType('image', 'png'),
        ),
      );
    }
    // ✅ Handle Mobile (Gallery & Camera)
    else if (!kIsWeb && imageDevice != null) {
      XFile imageFile = XFile(imageDevice.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    var response = await request.send();
    return response.statusCode == 201;
  }

  // ✅ Pick Image for Mobile (Gallery & Camera)
  Future<XFile?> pickImageMobile(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

  // ✅ Pick Image for Web
  Future<Uint8List?> pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      return result.files.first.bytes;
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchCommissionSummary({
    required BuildContext context,
  }) async {
    String? token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/commissionSummary'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.body.contains("Invalid token")) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch commission data');
      }
    }
  }

  Future<bool> createStock(
    String? metricId,
    String stockEvent,
    String? createdBy,
    int amount,
    String? salesId,
    String? subAgentId,
    String? agentId,
    String status,
    String? description,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stocks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'metricId': metricId,
        'stockEvent': stockEvent,
        'amount': amount,
        'createdBy': createdBy,
        'salesId': salesId,
        'subAgentId': subAgentId,
        'agentId': agentId,
        'status': status,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
