// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';

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

  /// AUTH ROUTES
  /// /register'
  /// /login',
  /// /refresh',
  /// /logout',
  Future<dynamic> login(String username, String password) async {
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
      return data;
    }
    return null;
  }

  Future<dynamic> self(BuildContext context, String refreshToken) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/self'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 403) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return null;
      }
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
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

  Future<bool> register({
    required String username,
    required String password,
    required String name,
    required String phone,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "name": name,
        "phone": phone,
        "email": email,
      }),
    );
    return response.statusCode < 400;
  }

  Future<dynamic> getAllUser(BuildContext context) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/auth/users'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return null;
      }
      return getAllUser(context);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return null;
    }
  }

  Future<bool> updateUser({
    required BuildContext context,
    required String id,
    required int? level,
    required String? status,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/auth/update/user/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'level': level, 'status': status}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      } else {
        return updateUser(
          context: context,
          id: id,
          level: level,
          status: status,
        );
      }
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  // TODO: PRODUCTS ROUTES
  /// GET /
  /// POST /
  Future<dynamic> fetchProduct(BuildContext context, String productId) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return null;
      }
      return fetchProduct(context, productId);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return null;
    }
  }

  Future<List<dynamic>> fetchProducts(BuildContext context) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return fetchProducts(context);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  // ✅ Create Product API with Image Upload
  Future<bool> createProduct({
    required BuildContext context,
    required String name,
    required String description,
    required String metric,
    required double price,
    required Uint8List? imageWeb,
    required XFile? imageDevice,
  }) async {
    String? token = await _getToken();
    if (token == null) {
      Navigator.pushNamed(context, signInRoute);
    }

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
    return response.statusCode == 200;
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
    required String fromDate,
    required String toDate,
  }) async {
    String? token = await _getToken();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/dashboard/commissionSummary?fromDate=$fromDate&toDate=$toDate',
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return {};
      }
      return fetchCommissionSummary(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
      );
    } else if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.body.contains("Invalid token")) {
        return json.decode(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.red.shade400,
            content: Text(
              jsonDecode(response.body)['error'] ??
                  "Kesalahan system, hubungi pengembang aplikasi",
            ),
          ),
        );
        throw Exception('Failed to fetch commission data');
      }
    }
  }

  // TODO: METRIC ROUTES
  /// GET /
  /// POST /
  ///
  Future<bool> createMetric(
    BuildContext context,
    String productId,
    String metricType,
    double price,
  ) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/metrics'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'productId': productId,
        'metricType': metricType,
        'price': price,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createMetric(context, productId, metricType, price);
    } else if (response.statusCode == 200) {
      fetchProduct(context, productId);
      Navigator.pop(context);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  // TODO: STOCKS ROUTES
  /// GET /
  /// POST /

  Future<dynamic> fetchStockByProduct(
    BuildContext context,
    String productId,
  ) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/stocks/product/$productId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return null;
      }
      return fetchStockByProduct(context, productId);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return null;
    }
  }

  Future<bool> createStock({
    // required BuildContext context,
    required String? metricId,
    required String stockEvent,
    required int amount,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String? shopId,
    required String status,
    required String? description,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/stocks'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'metricId': metricId,
        'stockEvent': stockEvent,
        'amount': amount,
        'salesId': salesId,
        'subAgentId': subAgentId,
        'agentId': agentId,
        'status': status,
        'description': description,
        'shopId': shopId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        // Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createStock(
        // context: context,
        metricId: metricId,
        stockEvent: stockEvent,
        amount: amount,
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
        shopId: shopId,
        status: status,
        description: description,
      );
    } else if (response.statusCode == 200) {
      // Navigator.pop(context);
      return true;
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     showCloseIcon: true,
      //     backgroundColor: Colors.red.shade400,
      //     content: Text(
      //       jsonDecode(response.body)['error'] ??
      //           "Kesalahan system, hubungi pengembang aplikasi",
      //     ),
      //   ),
      // );
      return false;
    }
  }

  Future<bool> createStockBatch({
    required Map<String, dynamic> batchData,
  }) async {
    String? token = await _getToken();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/stocks/batch'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(batchData), // Send the whole batch data as JSON
          )
          .timeout(
            const Duration(seconds: 30),
          ); // Adjust timeout for potentially longer batch operations

      if (response.statusCode == 401) {
        token = await refreshAccessToken();
        if (token == null) {
          // Navigator.pushNamed(context, signInRoute);
          return false;
        }
        return createStockBatch(batchData: batchData);
      } else if (response.statusCode >= 200 && response.statusCode < 300) {
        // Batch Success (e.g., 201 Created)
        if (kDebugMode) {
          print('Batch API Call Success: ${response.body}');
        }
        // Optionally parse response.body if backend sends back created items
        // var responseData = jsonDecode(response.body);
        return true; // Indicate success
      } else {
        // Server returned an error (e.g., 400 Bad Request, 500 Internal Server Error)
        if (kDebugMode) {
          print(
            'Batch API Call Failed: ${response.statusCode} ${response.body}',
          );
        }
        // Throw an exception with details from the response
        // Try to parse error message from backend response body
        String errorMessage = 'Batch purchase failed: ${response.statusCode}';
        try {
          var errorJson = jsonDecode(response.body);
          errorMessage =
              errorJson['error'] ?? (errorJson['details'] ?? errorMessage);
        } catch (_) {
          /* Ignore parsing error */
        }
        throw Exception(errorMessage);
      }
    } on TimeoutException catch (_) {
      throw Exception('Batch purchase request timed out.');
    } catch (e) {
      // Handle other errors (network issues, JSON encoding errors, etc.)
      if (kDebugMode) {
        print('Batch API Call Error: $e');
      }
      // Re-throw the original exception or a custom one
      rethrow;
    }
  }

  /// Date String yyyy-mm-dd, 2025-03-01
  Future<dynamic> getStockBatches({
    required BuildContext context,
    required String status,
    required String? fromDate,
    required String? toDate,
    required String? createdBy,
    required String? sortBy,
    required String? sortOrder,
    required int? page,
    required int? limit,
  }) async {
    String? token = await _getToken();
    // Build the query parameters map conditionally
    final Map<String, dynamic> queryParameters = {
      'status': status,
      // Only add ID parameters if they are not null and not empty
      if (fromDate != null && fromDate.isNotEmpty) 'fromDate': fromDate,
      if (toDate != null && toDate.isNotEmpty) 'toDate': toDate,
      if (createdBy != null && createdBy.isNotEmpty) 'createdBy': createdBy,
      if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
      if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
      if (page != null && page > 1) 'page': page,
      if (limit != null && limit > 1) 'limit': limit,
    };

    final uri = Uri.parse(baseUrl).replace(
      path:
          'service/api/stocks/batches', // Or adjust if baseUrl already includes part of the path
      queryParameters: queryParameters,
    );

    final response = await http.get(
      uri,
      // Uri.parse(
      //   '$baseUrl/stocks/table?fromDate=$fromDate&toDate=$toDate&status=$status&salesId=$salesId&subAgentId=$subAgentId&agentId=$agentId',
      // ),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getStockBatches(
        context: context,
        createdBy: createdBy,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
        limit: limit,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return null;
    }
  }

  Future<bool?> settleStockBatch({required String batchId}) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/stocks/batch/$batchId/settle'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        return null;
      }
      return settleStockBatch(batchId: batchId);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> cancelStockBatch({required String batchId}) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/stocks/batch/$batchId/cancel'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        return null;
      }
      return cancelStockBatch(batchId: batchId);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Date String yyyy-mm-dd, 2025-03-01
  Future<List<dynamic>> getStockTable({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String status,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
  }) async {
    String? token = await _getToken();
    // Build the query parameters map conditionally
    final Map<String, String> queryParameters = {
      'fromDate': fromDate,
      'toDate': toDate,
      'status': status,
      // Only add ID parameters if they are not null and not empty
      if (salesId != null && salesId.isNotEmpty) 'salesId': salesId,
      if (subAgentId != null && subAgentId.isNotEmpty) 'subAgentId': subAgentId,
      if (agentId != null && agentId.isNotEmpty) 'agentId': agentId,
    };

    final uri = Uri.parse(baseUrl).replace(
      path:
          'service/api/stocks/table', // Or adjust if baseUrl already includes part of the path
      queryParameters: queryParameters,
    );

    final response = await http.get(
      uri,
      // Uri.parse(
      //   '$baseUrl/stocks/table?fromDate=$fromDate&toDate=$toDate&status=$status&salesId=$salesId&subAgentId=$subAgentId&agentId=$agentId',
      // ),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getStockTable(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> getStockClientTable({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String status,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String? stockEvent,
  }) async {
    String? token = await _getToken();
    // Build the query parameters map conditionally
    final Map<String, String> queryParameters = {
      'fromDate': fromDate,
      'toDate': toDate,
      'status': status,
      // Only add ID parameters if they are not null and not empty
      if (salesId != null && salesId.isNotEmpty) 'salesId': salesId,
      if (subAgentId != null && subAgentId.isNotEmpty) 'subAgentId': subAgentId,
      if (agentId != null && agentId.isNotEmpty) 'agentId': agentId,
      if (stockEvent != null && stockEvent.isNotEmpty) 'stockEvent': stockEvent,
    };

    final uri = Uri.parse(baseUrl).replace(
      path:
          'service/api/stocks/table/client', // Or adjust if baseUrl already includes part of the path
      queryParameters: queryParameters,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getStockClientTable(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
        stockEvent: stockEvent,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  /// Date String yyyy-mm-dd, 2025-03-01
  Future<List<dynamic>> getStockHistoryTable({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String metricId,
    required String status,
  }) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/stocks/history?metricId=$metricId&fromDate=$fromDate&toDate=$toDate&status=$status',
      ),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getStockHistoryTable(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        metricId: metricId,
        status: status,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<bool> settlingStock({
    required BuildContext context,
    required String stockId,
    required String metricId,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/stocks/settled'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'id': stockId, 'metricId': metricId}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return settlingStock(
        context: context,
        stockId: stockId,
        metricId: metricId,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> cancelingStock({
    required BuildContext context,
    required String stockId,
    required String description,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/stocks/canceled'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'id': stockId, 'description': description}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return cancelingStock(
        context: context,
        stockId: stockId,
        description: description,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  //   const { fromDate, toDate, salesId, subAgentId, agentId, shopId } = req.body;
  Future<dynamic> getStockResume({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String? shopId,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/stocks/table/resume'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'salesId': salesId,
        'agentId': agentId,
        'subAgentId': subAgentId,
        'shopId': shopId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return null;
      }
      return getStockResume(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        salesId: salesId,
        agentId: agentId,
        subAgentId: subAgentId,
        shopId: shopId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return null;
    }
  }

  Future<List<dynamic>> getTableBySalesId({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String salesId,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/stocks/table/salesman'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'salesId': salesId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getTableBySalesId(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        salesId: salesId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> getTableBySubAgentId({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String subAgentId,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/stocks/table/subAgent'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'subAgentId': subAgentId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getTableBySubAgentId(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        subAgentId: subAgentId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> getTableByAgentId({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String agentId,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/stocks/table/agent'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'agentId': agentId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getTableByAgentId(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        agentId: agentId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> getTableByShopId({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required String shopId,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/stocks/table/shop'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'shopId': shopId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getTableByShopId(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        shopId: shopId,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  // TODO: CLIENTS ROUTES
  /// GET /
  /// POST /

  Future<bool> createSalesman({
    required BuildContext context,
    required String name,
    required String address,
    required String phone,
    required String email,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/salesmen'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createSalesman(
        context: context,
        name: name,
        address: address,
        phone: phone,
        email: email,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<List<dynamic>> getSalesmen({required String? status}) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/salesmen?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<bool> createSubAgent({
    required BuildContext context,
    required String name,
    required String address,
    required String phone,
    required String email,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/subagents'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createSubAgent(
        context: context,
        name: name,
        address: address,
        phone: phone,
        email: email,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<List<dynamic>> getSubAgents(
    BuildContext context,
    String? status,
  ) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/subagents?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getSubAgents(context, status);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<bool> createAgent({
    required BuildContext context,
    required String name,
    required String address,
    required String phone,
    required String email,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/agents'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createAgent(
        context: context,
        name: name,
        address: address,
        phone: phone,
        email: email,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<List<dynamic>> getAgents(BuildContext context, String? status) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/agents?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getAgents(context, status);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  // TODO: SHOP ROUTES
  /// GET
  /// POST

  Future<bool> createShop({
    required BuildContext context,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String name,
    required String address,
    required String phone,
    required String? email,
    required String? imageUrl,
    required String? coordinates,
  }) async {
    String? token = await _getToken();
    // { name, image, address, coordinates, phone, email, updateBy }
    final response = await http.post(
      Uri.parse('$baseUrl/shops'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'salesId': salesId,
        'subAgentId': subAgentId,
        'agentId': agentId,
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'image': imageUrl,
        'coordinates': coordinates,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return createShop(
        context: context,
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
        name: name,
        address: address,
        phone: phone,
        email: email,
        imageUrl: imageUrl,
        coordinates: coordinates,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<List<dynamic>> getAllShopsBySales({
    required BuildContext context,
    required String salesId,
  }) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/shops/$salesId'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getAllShopsBySales(context: context, salesId: salesId);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> getAllShops({required BuildContext context}) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/shops'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getAllShops(context: context);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<bool> updateShop({
    required BuildContext context,
    required String? id,
    required String? name,
    required String? image,
    required String? address,
    required String? coordinates,
    required String? phone,
    required String? email,
    required String? status,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/shops/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'image': image,
        'address': address,
        'coordinates': coordinates,
        'phone': phone,
        'email': email,
        'status': status,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return updateShop(
        id: id,
        context: context,
        name: name,
        image: image,
        address: address,
        coordinates: coordinates,
        phone: phone,
        email: email,
        status: status,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  // TODO: FREEZER ROUTES
  /// GET
  /// POST

  Future<List<dynamic>> getAllFreezer(BuildContext context) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/refrigerators'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return [];
      }
      return getAllFreezer(context);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return [];
    }
  }

  Future<bool> addFrezer({
    required BuildContext context,
    required String name,
    required String capacity,
    required String serialNumber,
    required String? coordinates,
  }) async {
    String? token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/refrigerators'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'capacity': capacity,
        'serialNumber': serialNumber,
        'coordinates': coordinates,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return addFrezer(
        context: context,
        name: name,
        capacity: capacity,
        serialNumber: serialNumber,
        coordinates: coordinates,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> updateFreezerShop({
    required BuildContext context,
    required String id,
    required String shopId,
    required String status,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/refrigerators/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'shopId': shopId, 'status': status}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return updateFreezerShop(
        context: context,
        id: id,
        shopId: shopId,
        status: status,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> returnFreezer({
    required BuildContext context,
    required String id,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/refrigerators/return/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return returnFreezer(context: context, id: id);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> updateFreezerStatus({
    required BuildContext context,
    required String id,
    required String status,
    required String? description,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/refrigerators/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'status': status, 'description': description}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) {
        Navigator.pushNamed(context, signInRoute);
        return false;
      }
      return updateFreezerStatus(
        context: context,
        id: id,
        status: status,
        description: description,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(
            jsonDecode(response.body)['error'] ??
                "Kesalahan system, hubungi pengembang aplikasi",
          ),
        ),
      );
      return false;
    }
  }
}
