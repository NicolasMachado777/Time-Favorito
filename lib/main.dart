import 'package:flutter/material.dart';
import 'package:times/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Favorito',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
