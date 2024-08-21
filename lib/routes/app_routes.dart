import 'package:flutter/material.dart';
import 'package:flutter_cubit_task/view/home/home_screen.dart';

import '../view/login_screen/login_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    initialRoute: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
  };
}
