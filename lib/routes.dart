import 'package:flutter/material.dart';
import 'package:times/screens/home/home_screen.dart';
import 'package:times/screens/select/select_screen.dart';

class Routes {
  static const String home = '/';
  static const String select = '/select';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case select:
        return MaterialPageRoute(builder: (_) => SelectScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada!'),
            ),
          ),
        );
    }
  }
}
