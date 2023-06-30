// ignore_for_file: file_names
import 'dart:async';

import 'package:chess_toturial/game_board.dart';
import 'package:chess_toturial/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

// ignore: camel_case_types
class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const game_board())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: foregroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 280,
            ),
            Center(
              child: TweenAnimationBuilder(
                  tween: Tween(begin: 1.0, end: 35.0),
                  duration: const Duration(seconds: 2),
                  builder:
                      (BuildContext context, double? value, Widget? child) {
                    return Text(
                      'CHECK MATE!',
                      style: TextStyle(
                          fontSize: value,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }),
            ),
            const Spacer(),
            Lottie.asset('assets/images/107247-icon-chess.json'),
          ],
        ));
  }
}
