import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/ApiService.dart';
import '../widgets/QRCodeScanner.dart';
import '../widgets/ScannedCardDisplay.dart';
import '../widgets/DetailInfoDisplay.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String scannedCode = 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
  MobileScannerController? controller;

  final TextEditingController _manualCodeController = TextEditingController();

  Map<String, dynamic>? _apiData;
  List<Map<String, dynamic>> matchedData = [];
  bool isCameraGranted = false;

  String _lastProcessedId = '';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _cardKey = GlobalKey();

  final String defaultImagePath = 'assets/istockphoto-1300845620-612x612.jpg';
  final String defaultQrCodePath = 'assets/Data not found!.jpeg';
  final String policeLogo = 'assets/policelogo.png';

  final String apiStatus = 'FINISHED';
  final String apiAuthorizationToken =
      'Bearer eyJhbGciOiJQUzUxMiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicGhvbmUiOiI5OTkyNTkyMiIsInJvbGUiOiJTVVBFUl9BRE1JTiIsImZpcnN0TmFtZSI6InN1cGVyYWRtaW4iLCJlbWFpbCI6ImtvdW5AZ21haWwuY29tIiwib2ZmaWNlSWQiOm51bGwsImxhc3ROYW1lIjoiQWRtaW5pc3RyYXRvciIsInVzZXJuYW1lIjoiYWRtaW4iLCJ1c2VyT2ZmaWNlIjpbXSwiaWF0IjoxNzUwMjQxOTY3LCJleHAiOjE3NTAzMjgzNjcsImF1ZCI6Imh0dHBzOi8vdGhhdmlzb3VrbW5sdi5jb20iLCJpc3MiOiJCb2lsZXJwbGF0ZSIsInN1YiI6IlRoYXZpc291a21ubHZAZ21haWwuY29tIn0.wK8tAngAcpnCZJb6RkjVzzv5FpHmJRUfaVVnjHHCdoIgRiSbUc2g7RfKT5Kygd2hxTSvCRAeO1jym7GpdLdcF4WvoMpkoYZ4NoFVe1HX12zcr_6UvERUNjOoYDaq2k0m-xZagLRTvhwfTYVWpi7SN9QlywG-wj_JYxbkbZEazFGjBxaPVAdqKjnfIYsBFSm8eIwY9kACnwKwDnNxyjVj6WjGzQmFJ9euohFXcWwH6TL4CglDv6d9T05rJhvhoLfD-3i4mSWCqmQIdI200wX58hkqYHV-n11Qb2L6of1hi-9E-LOC6sTfR4nCF7dynkI-efJjqO3N7oLzMaC4BI0d4lxFqQSEZ6mxZ57ZLdO03eV9mLCTfJmfS-pFIjbmSOUA3hrviORTHguvZGI6kdItlceaZaueA2G6zRtSW3GXpQqDqO3i6XcPx6fnbTnKusQHO_8FpXtYlLeR3w3jdXzn818gI2Uzke1nAsuhpFNfp6_dV_GY6kYiuK25yPj75AVi3N0-QtkA39P1c0QSNXALHMA9guSApNZIuck2tT6ZWTd3y-4at_hQdvoRGC1ngs1kskt7xoxdnGHVy_Sjyn1QeqOVI1om-BWzOz-igMUUFDnJ_kp6uDp8TK-Fy-xPO36OKNrOdPqsD_orJaen40hD06bezDCUtreAtwKLg6t1kEA';

  String currentVillageName = '';
  String overseasCountryName = '';

  Future<Map<String, dynamic>> fetchProfileById(String profileId) async {
    final url = 'https://bn.skillgener.com/profile/$profileId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': apiAuthorizationToken,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody['result'] is List && jsonBody['result'].isNotEmpty) {
        final profile = jsonBody['result'][0];
        print('Profile Data: $profile');
        return profile;
      } else if (jsonBody['result'] is Map) {
        final profile = jsonBody['result'];
        print('Profile Data: $profile');
        return profile;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch profile data: ${response.statusCode}');
    }
  }

  void _fetchProfileNames(String profileId) async {
    try {
      final profileData = await fetchProfileById(profileId);

      setState(() {
        currentVillageName = profileData['currentVillage']?['villageLao'] ?? '';
        overseasCountryName = profileData['overseasCountry']?['name'] ?? '';
      });

      print("currentVillageName: $currentVillageName");
      print("overseasCountryName: $overseasCountryName");
    } catch (e) {
      print('Error fetching profile details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    _requestCameraPermission();
  }

  void _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (mounted) {
      setState(() {
        isCameraGranted = status.isGranted;
        if (isCameraGranted) {
          if (controller == null) {
            controller = MobileScannerController();
          }
          controller?.start();
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _scrollController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (matchedData.isNotEmpty ||
        (scannedCode != 'ລໍຖ້າສະແກນຄິວອາໂຄດ...' && scannedCode != '')) {
      controller?.stop();
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;

      if (code != null) {
        print('ค่าที่ได้จาก QR Code: $code');

        _lastProcessedId = code;
        _processCode(code);
        controller?.stop();
      } else {
        setState(() {
          scannedCode = 'ບໍ່ມີຂໍ້ມູນ!';
        });
      }
    }
  }

  void _processCode(String code) async {
    setState(() {
      scannedCode = 'ກຳລັງດຶງຂໍ້ມູນ...';
      matchedData = [];
    });

    try {
      final fetchedData = await ApiService.fetchApplicationByBarcode(
        barcode: code,
        status: apiStatus,
        authorizationToken: apiAuthorizationToken,
      );

      if (fetchedData != null && fetchedData.isNotEmpty) {
        setState(() {
          matchedData = [fetchedData];
          _apiData = fetchedData;
          scannedCode = '';
          _manualCodeController.clear();
          _lastProcessedId = '';
          _fetchProfileNames(fetchedData['profile']['id'].toString());
        });
      } else {
        setState(() {
          matchedData = [];
          _apiData = null;
          scannedCode = 'ໄອດີ $_lastProcessedId ບໍ່ມີຂໍ້ມູນ';
        });
      }
    } catch (e) {
      setState(() {
        matchedData = [];
        _apiData = null;
        scannedCode = 'ເກີດຂໍ້ຜິດພາດໃນການດຶງຂໍ້ມູນ: $e';
      });
    }
  }

  void _resetScreen() {
    controller?.dispose();
    controller = MobileScannerController();
    controller?.start();

    setState(() {
      matchedData = [];
      _apiData = null;
      scannedCode = 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
      _manualCodeController.clear();
      _lastProcessedId = '';
    });
  }

  String _getNestedValue(String key) {
    Map<String, dynamic>? currentData = _apiData;

    if (currentData == null || currentData.isEmpty) {
      return '';
    }

    List<String> parts = key.split('.');
    dynamic current = currentData;

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return '';
      }
    }
    return current?.toString() ?? '';
  }

  String _getValue(String key) {
    if (key == 'fullName') {
      return '${_getNestedValue("profile.firstName")} ${_getNestedValue("profile.lastName")}'
          .trim()
          .toUpperCase();
    } else if (key == 'number.price.price') {
      final price = _getNestedValue(key);
      if (price.isNotEmpty) {
        return '\$$price';
      }
      return '';
    } else if (key == 'profile.identityExpiryDate' ||
        key == 'profile.identityIssueDate' ||
        key == 'profile.dateOfBirth') {
      final dateString = _getNestedValue(key);
      if (dateString.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(dateString);
          return DateFormat('dd/MM/yyyy').format(dateTime);
        } catch (e) {
          print('Error parsing date for $key: $e');
          return dateString;
        }
      }
      return '';
    } else if (key == 'profile.currentVillage') {
      return _getNestedValue('profile.currentVillage.villageLao');
    } else if (key == 'profile.overseasCountry') {
      return _getNestedValue('profile.overseasCountry.name');
    }

    return _getNestedValue(key);
  }

  String _getLocalizedLabel(String? key) {
    if (key == null) return '';
    switch (key) {
      case 'profile.identityNumber':
        return 'ເລກຟອມ:';
      case 'profile.phoneNumber':
        return 'ເບີໂທ:';
      case 'profile.dateOfBirth':
        return 'ວັນເດືອນປີເກີດ:';
      case 'profile.identityType':
        return 'ປະເພດເອກະສານ:';
      case 'profile.gender':
        return 'ເພດ:';
      case 'profile.nationality.name':
        return 'ສັນຊາດ:';
      case 'profile.ethnicity.name':
        return 'ເຊື້ອຊາດ:';
      case 'profile.currentVillageId':
        return 'ບ້ານ:';
      case 'profile.district.districtLao':
        return 'ເມືອງ:';
      case 'profile.province.provinceLao':
        return 'ແຂວງ:';
      case 'profile.identityIssueDate':
        return 'ອອກໃຫ້ວັນທີ:';
      case 'profile.identityExpiryDate':
        return 'ວັນໝົດວັນທີ:';
      case 'number.number':
        return 'ເລກທີ່:';
      case 'profile.overseasProvince':
        return 'ແຂວງ:';
      case 'type':
        return 'ປະເພດ:';
      case 'number.price.type':
        return 'ປະເພດບັດ:';
      case 'number.price.price':
        return 'ລາຄາ:';
      case 'number.price.duration':
        return 'ໄລຍະເວລາ:';
      case 'company.name':
        return 'ບໍລິສັດ:';
      case 'company.officeId':
        return 'ລະຫັດທຸລະກິດ:';
      case 'position.laoName':
        return 'ຕຳແໜ່ງ:';
      case 'office.name':
        return 'ສຳນັກງານ:';
      case 'profile.overseasCountryId':
        return 'ປະເທດ:';
      default:
        return key;
    }
  }

  bool get _shouldShowResetButton {
    if (matchedData.isNotEmpty) return true;
    if (scannedCode != 'ລໍຖ້າສະແກນຄິວອາໂຄດ...') return true;
    return false;
  }

  bool get _shouldShowInputAndScanner {
    return matchedData.isEmpty && scannedCode == 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = _getValue("profile.image");
    final String qrcodeUrlFromApi = _getValue("profile.barcode");
    print("qrcodeUrlFromApi: $qrcodeUrlFromApi");

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              if (_shouldShowInputAndScanner)
                Column(
                  children: [
                    if (isCameraGranted)
                      QRCodeScanner(
                        controller: controller,
                        onDetect: _onDetect,
                        isCameraGranted: isCameraGranted,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("ກຳລັງຂໍສິດໃຊ້ກ້ອງ..."),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _manualCodeController,
                            decoration: InputDecoration(
                              labelText: 'ປ້ອນເລກຄິວອາໂຄດ ຫຼື ID',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _manualCodeController.clear();
                                },
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _lastProcessedId = value;
                                _processCode(value);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_manualCodeController.text.isNotEmpty) {
                                  _lastProcessedId = _manualCodeController.text;
                                  _processCode(_manualCodeController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  230,
                                  192,
                                  137,
                                ),
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                shadowColor: const Color.fromARGB(
                                  255,
                                  191,
                                  191,
                                  191,
                                ),
                              ),
                              child: const Text(
                                'ກວດສອບຂໍ້ມູນ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (matchedData.isNotEmpty)
                Column(
                  children: [
                    ScannedCardDisplay(
                      imageUrl: imageUrl,
                      qrcodeUrl: qrcodeUrlFromApi,
                      defaultImagePath: defaultImagePath,
                      defaultQrCodePath: defaultQrCodePath,
                      policeLogo: policeLogo,
                      cardKey: _cardKey,
                      getLocalizedLabel: _getLocalizedLabel,
                      getValue: _getValue,
                    ),
                    const SizedBox(height: 20),
                    DetailInfoDisplay(
                      getLocalizedLabel: _getLocalizedLabel,
                      getValue: _getValue,
                    ),
                  ],
                )
              else if (scannedCode != 'ລໍຖ້າສະແກນຄິວອາໂຄດ...')
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    scannedCode,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 20),
              if (_shouldShowResetButton)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          230,
                          192,
                          137,
                        ),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        shadowColor: const Color.fromARGB(255, 191, 191, 191),
                      ),
                      child: const Text(
                        'ສະແກນໃໝ່',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
