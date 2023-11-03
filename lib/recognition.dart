import 'package:flutter/material.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/app_input_button_component.dart';

class Recognition extends StatelessWidget {
  const Recognition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recognition"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppInputButtonComponent(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.ImageToText);
                  },
                  buttonText: "Image To Text"),
              SizedBox(
                height: 20,
              ),
              AppInputButtonComponent(
                  onPressed: () {
                    print("5678678");
                    Navigator.pushNamed(context, AppRoutes.VoiceToText);
                  }, buttonText: "Voice To Text"),
              SizedBox(
                height: 20,
              ),
              AppInputButtonComponent(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.ObjectDetectionPage);
                  }, buttonText: "Object Detection"),
            ],
          ),
        ),
      ),
    );
  }
}
