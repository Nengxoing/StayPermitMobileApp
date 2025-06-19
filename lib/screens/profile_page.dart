import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String defaultImagePath = 'assets/istockphoto-1300845620-612x612.jpg';
  final String defaultQrCodePath = 'assets/Data not found!.jpeg';
  final String policeLogo = 'assets/policelogo.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ໂປຣໄຟລ໌',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset(defaultImagePath, width: 200, height: 200),
      ],
    );
  }
}
