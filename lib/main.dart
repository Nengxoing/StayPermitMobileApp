import 'package:flutter/material.dart';
import 'package:staypermitmobileapp/routes/route_app.dart';
import 'package:staypermitmobileapp/screens/login/LoginScreen.dart';
import 'package:get/get.dart';

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteApp.login,
      getPages: RouteApp.routes,
    );
  }
}
