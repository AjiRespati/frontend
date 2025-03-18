import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class FileService {
  static Future<http.StreamedResponse> uploadImage(File imageFile, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/api/uploads/image'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    request.headers['Authorization'] = 'Bearer \$token';
    return await request.send();
  }
}
