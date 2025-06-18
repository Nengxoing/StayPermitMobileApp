import 'package:get/get.dart';
import 'package:staypermitmobileapp/screens/ContactScreen.dart';
import 'package:staypermitmobileapp/screens/Donutchart.dart';
import 'package:staypermitmobileapp/screens/HomeScreen.dart';
import 'package:staypermitmobileapp/screens/ProfileScreen.dart';
import 'package:staypermitmobileapp/screens/ScanScreen.dart';
import 'package:staypermitmobileapp/screens/login/LoginScreen.dart';

class RouteApp {
  static String login = "/";
  static String home = "/home";
  static String scan = "/scan";
  static String profile = "/profile";
  static String contact = "/contact";

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: home,
      page: () {
        final role = Get.arguments?['role'] ?? 'USER'; // default fallback
        return HomeScreen(role: role);
      },
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: scan,
      page: () => ScanScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: contact,
      page: () => ContactScreen(),
      transition: Transition.leftToRight,
    ),
  ];
}
