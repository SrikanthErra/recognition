import 'package:flutter/cupertino.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/image_to_text.dart';
import 'package:text_recognition_ocr_scanner/object_detector.dart';
import 'package:text_recognition_ocr_scanner/recognition.dart';
import 'package:text_recognition_ocr_scanner/voice_to_text.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.ImageToText: ((context) => ImageToText()),
      AppRoutes.Recognition: ((context) => Recognition()),
      AppRoutes.VoiceToText: ((context) => VoiceToText()),
      //AppRoutes.ObjectDetectionPage: ((context) => ObjectDetectionPage()),
      // AppRoutes.PrivacyPolicyView: ((context) => PrivacyPolicyView()),
      // AppRoutes.InspectorSurveyReport: ((context) => InspectorSurveyReport()),
      // AppRoutes.SplashTwoScreen: ((context) => SplashTwoScreen()),
      // AppRoutes.LogIn: ((context) => LogIn()),
      // AppRoutes.LogIn: ((context) => LogIn()),
      // AppRoutes.LogIn: ((context) => LogIn()),
    };
  }
}
