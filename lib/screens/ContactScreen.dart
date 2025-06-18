import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Color(0xFFF5D9AE)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ຕິດຕໍ່ພວກເຮົາ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('020-1234-5678'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('info@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Vientiane Capital, Laos'),
            ),
            SizedBox(height: 30),
            Text('ສົ່ງຂໍ້ຄວາມ', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'ຂໍ້ຄວາມຂອງທ່ານ',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('ສົ່ງ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5D9AE)
              ),
            )
          ],
        ),
      ),
    );
  }
}
