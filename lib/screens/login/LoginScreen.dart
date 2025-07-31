import 'package:flutter/material.dart';
import 'package:staypermitmobileapp/routes/route_app.dart';
import 'package:staypermitmobileapp/statemanage/LoginState.dart';
import 'package:staypermitmobileapp/statemanage/app_verification_state.dart';
import 'package:staypermitmobileapp/widgets/dialog_app_widget.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final DialogAppWidget fToast = DialogAppWidget();
  LoginState loginState = Get.put(LoginState());
  AppVerificationState appVerificationState = Get.put(AppVerificationState());

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    await appVerificationState.initialize();
    if (appVerificationState.accessToken.isNotEmpty) {
      Navigator.pushReplacementNamed(context, RouteApp.home);
    } else {
      Navigator.pushReplacementNamed(context, RouteApp.login);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/ministryOfJustice.jpg", fit: BoxFit.cover),
            Center(
              child: SingleChildScrollView(
                // ← Add this
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade400, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/policelogo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ເຂົ້າສູ່ລະບົບກົມຕຳຫຼວດ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'ຊື່ຜູ້ໃຊ້',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'ລະຫັດຜ່ານ',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool loginSuccess = await loginState.login(
                              context: context,
                              username: _usernameController.text,
                              password: _passwordController.text,
                            );

                            if (loginSuccess && mounted) {
                              Get.offAllNamed(
                                RouteApp.home,
                              ); // Add this navigation
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFFF5D9AE),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.login_outlined,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'ເຂົ້າສູ່ລະບົບ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
