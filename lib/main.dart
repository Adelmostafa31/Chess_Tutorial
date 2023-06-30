import 'package:chess_toturial/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const chess());
}

class chess extends StatelessWidget {
  const chess({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess',
      home: splashScreen(),
    );
  }
}
