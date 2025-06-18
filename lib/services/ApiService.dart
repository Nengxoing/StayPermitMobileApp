// D:\Nengxiong\Code\staypermitmobileapp\lib\services\ApiService.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchApplicationData({
    required String status,
    required String authorizationToken,
  }) async {
    try {
      print(
        'Sending API request to: https://bn.skillgener.com/application?status=$status',
      );
      print('Authorization Token: $authorizationToken');

      final response = await http.get(
        Uri.parse('https://bn.skillgener.com/application?status=$status'),
        headers: {
          'Authorization': authorizationToken,
          'Accept': 'application/json',
        },
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('API returned empty body.');
          throw Exception('API returned empty data.');
        }

        final dynamic decodedData = json.decode(response.body);
        print('Decoded Data: $decodedData');

        if (decodedData is Map<String, dynamic> &&
            decodedData.containsKey('result')) {
          final List<dynamic>? resultList = decodedData['result'];

          if (resultList == null || resultList.isEmpty) {
            print('No data found in API result.');
            throw Exception('No application data found.');
          }

          final List<Map<String, dynamic>> finalData = resultList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          print('Final Parsed Data: $finalData');
          return finalData;
        } else {
          print('Unexpected data format from API.');
          throw Exception('Unexpected data format from API.');
        }
      } else {
        print(
          'Failed to load data. Status Code: ${response.statusCode}. Response body: ${response.body}',
        );
        throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}. Response body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching data in ApiService: $e');
      throw Exception('Error fetching data: $e');
    }
  }
}
