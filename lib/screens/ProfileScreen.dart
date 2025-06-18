import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatelessWidget {
  final String userId = 'LFR-12345';
  final String userName = 'MS THOUN LINH';
  final String userlastName = 'OU';
  final int userAge = 28;
  final String birthday = '01/06/1997';
  final String userNationa = "MMR";
  final String userNationality = "MMR";
  final String created_at = '06/01/2011';
  final String country = 'Myanmar';
  final String province = 'Yangon';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມູນສ່ວນຕົວ'),
        backgroundColor: Color(0xFFF5D9AE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ID Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/profile.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('ລະຫັດ: $userId'),
                          Text('ຊື່: $userName'),
                          Text('ນາມສະກຸນ: $userlastName'),
                          Text('ວັນທີ່ເກີດ: $birthday'),
                          Text('ອາຍຸ: $userAge'),
                          Text('ເສື້ອຊາດ: $userNationa'),
                          Text('ສັນຊາດ: $userNationality'),
                          Text('ລົງວັນທີ່: $created_at'),
                          Text('ທີ່ຢູ່ຕ່າງປະເທດ: $country'),
                          Text('ແຂວງ: $province'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            // QR Code
            Text('Scan this QR Code:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            QrImageView(data: userId, version: QrVersions.auto, size: 150.0),
          ],
        ),
      ),
    );
  }
}
