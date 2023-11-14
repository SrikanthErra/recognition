import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/app_input_button_component.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Recognition extends StatefulWidget {
  const Recognition({super.key});

  @override
  State<Recognition> createState() => _RecognitionState();
}

class _RecognitionState extends State<Recognition> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

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
                  onPressed: () async {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo =
                        await deviceInfo.androidInfo;
                    print("deviceInfo ${androidInfo.supportedAbis}");
                    print("5678678");
                    Navigator.pushNamed(context, AppRoutes.VoiceToText);
                  },
                  buttonText: "Voice To Text"),
              SizedBox(
                height: 20,
              ),
              AppInputButtonComponent(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.CameraView);
                  },
                  buttonText: "Object Detection"),
              SizedBox(
                height: 20,
              ),
              AppInputButtonComponent(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.NumberPlateCameraView);
                  },
                  buttonText: "Number Plate Detection"),
            ],
          ),
        ),
      ),
    );
  }
}
