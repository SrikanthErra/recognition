import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/res/app_constants.dart';
import 'package:text_recognition_ocr_scanner/res/custom_warning_alert.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';

class SideMenuViewModel with ChangeNotifier {
  navigationTo(
    BuildContext context,
    subtitle,
  ) async {
    if (subtitle == 'Home') {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppRoutes.Recognition);
    } else if (subtitle == 'Image to Text') {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.ImageToText);
    } else if (subtitle == 'Voice to Text') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.VoiceToText,
      );
    } else if (subtitle == 'Object Detection') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.CameraView,
      );
    } 
    else if (subtitle == 'Number Plate Detection') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.NumberPlateCameraView,
      );
    }
    else if (subtitle == 'Privacy Policy') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.PrivacyPolicyView,
      );
    } else if (subtitle == 'App Info') {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.AppInfoScreen);
    } else if (subtitle == 'Exit application') {
      Navigator.pop(context);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomWarningAlert(
              descriptions: "Are you sure you want to exit the application?",
              onPressed: () {
                Navigator.pop(context);
              },
              Img: AssetPath.warning,
              onPressed1: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              version: AppConstants.version_number ?? '');
          
        },
      );
    } else if (subtitle == 'Logout') {
      Navigator.pop(context);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomWarningAlert(
              descriptions: "Are you sure you want to logout the application?",
              onPressed: () {
                Navigator.pop(context);
              },
              Img: AssetPath.warning,
              onPressed1: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.Recognition),
              version: AppConstants.version_number ?? '');
          
        },
      );
    }
  }
}
