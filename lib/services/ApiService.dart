// D:\Nengxiong\Code\staypermitmobileapp\lib\services\ApiService.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchApplicationData({
    required String status,
    required String authorizationToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('https://bn.skillgener.com/application?status=$status'),
        headers: {
          'Authorization': authorizationToken,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API returned empty data.');
        }

        final decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic> &&
            decodedData.containsKey('result')) {
          final resultList = decodedData['result'];

          if (resultList == null || resultList.isEmpty) {
            throw Exception('No application data found.');
          }

          return List<Map<String, dynamic>>.from(resultList);
        } else {
          throw Exception('Unexpected data format from API.');
        }
      } else {
        throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}.',
        );
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
