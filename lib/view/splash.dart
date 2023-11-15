import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_recognition_ocr_scanner/dashboard.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPath.splash), fit: BoxFit.cover),
          ),
        )
      ],
    ));
  }

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Recognition(),
        ),
      ),
    );
  }
}
