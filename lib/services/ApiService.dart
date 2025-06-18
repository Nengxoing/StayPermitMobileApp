import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>?> fetchApplicationByBarcode({
    required String barcode,
    required String status,
    required String authorizationToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://bn.skillgener.com/application?barcode=$barcode&status=$status',
        ),
        headers: {
          'Authorization': authorizationToken,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null; // API คืนค่าข้อมูลว่างเปล่า ถือว่าไม่พบ
        }

        final decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic> &&
            decodedData.containsKey('result')) {
          final result = decodedData['result'];

          if (result == null || result.isEmpty) {
            return null; // ไม่พบข้อมูลแอปพลิเคชันสำหรับบาร์โค้ดนี้
          }

          // API คืนค่าเป็น list แต่เราคาดหวังแอปพลิเคชันที่ตรงกันเพียงอันเดียว
          // หากพบบาร์โค้ด ดังนั้นเราจะนำรายการแรก
          if (result is List && result.isNotEmpty) {
            return Map<String, dynamic>.from(result[0]);
          } else if (result is Map<String, dynamic>) {
            return result; // ในกรณีที่ API คืนค่า object โดยตรง
          } else {
            throw Exception('รูปแบบข้อมูลที่ไม่คาดคิดสำหรับ result จาก API');
          }
        } else {
          throw Exception('รูปแบบข้อมูลระดับบนสุดที่ไม่คาดคิดจาก API');
        }
      } else {
        throw Exception(
          'โหลดข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}.',
        );
      }
    } catch (e) {
      print('ข้อผิดพลาดในการดึงข้อมูลสำหรับบาร์โค้ด $barcode: $e');
      throw Exception('ข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }
}
