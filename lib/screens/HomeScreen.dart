import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staypermitmobileapp/screens/ContactScreen.dart';
import 'package:staypermitmobileapp/screens/Donutchart.dart';
import 'package:staypermitmobileapp/screens/ProfileScreen.dart';
import 'package:staypermitmobileapp/screens/ScanScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:staypermitmobileapp/statemanage/ProfileAggregationState.dart';
import 'package:staypermitmobileapp/statemanage/ApplicationAggregationState.dart';
import 'package:staypermitmobileapp/statemanage/app_verification_state.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appVerificationState = Get.find<AppVerificationState>();
  final ProfileAggregationState profileState =
      Get.isRegistered<ProfileAggregationState>()
      ? Get.find<ProfileAggregationState>()
      : Get.put(ProfileAggregationState());

  final ApplicationAggregationState applicationState =
      Get.isRegistered<ApplicationAggregationState>()
      ? Get.find<ApplicationAggregationState>()
      : Get.put(ApplicationAggregationState());

  late String role;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    role = appVerificationState.userRole ?? 'USER';
    profileState.fetchProfileAggregation(
      startDate: '2025-01-05',
      endDate: '2025-01-11',
    );
    applicationState.fetchApplicationAggregation(
      startDate: '2025-01-05',
      endDate: '2025-01-11',
    );

    // profileState.testValues();
    print("Init role: $role");
  }

  List<Widget> get _navItems {
    if (role == 'SUPER_ADMIN') {
      return const <Widget>[Icon(Icons.home), Icon(Icons.qr_code_scanner)];
    } else if (role == 'ADMIN') {
      return const <Widget>[Icon(Icons.person)];
    } else {
      return const <Widget>[Icon(Icons.qr_code_scanner)];
    }
  }

  Widget buildCard(String title, String value, Color color) {
    final formattedValue = NumberFormat(
      '#,###',
    ).format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$formattedValue ຄົນ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group 1: ຈຳນວນບັດ
            Text(
              'ຈຳນວນຄັ້ງອອກບັດ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                Obx(
                  () => buildCard(
                    'ທັງໝົດ',
                    '${applicationState.total.value}',
                    Colors.lightBlue,
                  ),
                ),
                Obx(
                  () => buildCard(
                    'ເພດຍິງ',
                    '${applicationState.female.value}',
                    Colors.red.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Group 2: ຈຳນວນຜູ້ລົງທະບຽນ
            Text(
              'ຈຳນວນຜູ້ລົງທະບຽນ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                Obx(
                  () => buildCard(
                    'ທັງໝົດ',
                    '${profileState.total.value}',
                    Colors.orange,
                  ),
                ),
                Obx(
                  () => buildCard(
                    'ເພດຍິງ',
                    '${profileState.female.value}',
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            DonutChartWidget(sumIncome: 1200000, sumExpense: 800000),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (role == 'SUPER_ADMIN') {
      switch (_selectedIndex) {
        case 0:
          return _buildHomeContent();
        case 1:
          return ScanScreen();
        default:
          return Container();
      }
    } else if (role == 'ADMIN') {
      return ProfileScreen(); // Only ProfileScreen for ADMIN
    } else {
      return ScanScreen(); // Only ScanScreen for others
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ກົມຕຳຫຼວດ'),
        backgroundColor: Color(0xFFF5D9AE),
      ),
      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        color: Color(0xFFF5D9AE),
        buttonBackgroundColor: Color(0xFFF5D9AE),
        animationDuration: Duration(milliseconds: 300),
        items: _navItems,
      ),
    );
  }
}
