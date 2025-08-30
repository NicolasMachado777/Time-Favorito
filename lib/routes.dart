import 'package:flutter/material.dart';
import 'package:times/screens/home/home_screen.dart';
import 'package:times/screens/intro/intro_screen.dart';
import 'package:times/screens/select/select_screen.dart';
import 'package:times/screens/splash/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String select = '/select';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case intro:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case select:
        return MaterialPageRoute(builder: (_) => SelectScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota não encontrada!'))),
        );
    }
  }
}
