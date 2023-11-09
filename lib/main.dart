import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_pages.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/cropped_cameraview.dart';
import 'package:text_recognition_ocr_scanner/result_screen.dart';

import 'package:image_cropper/image_cropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Text Recognition',
      initialRoute: AppRoutes.initial,
        routes: AppPages.routes,
        /* theme: ThemeData(
          primarySwatch: AppColors.navy,
        ), */
        //home: SideMenu(),
        //builder: EasyLoading.init(),
      /* theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ), */
      //home: const MyHomePage(),
    );
  }
}

