import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:text_recognition_ocr_scanner/view_model/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<ScancodeController>(
            init: ScancodeController(),
            builder: (controller) {
              if (controller.isCameraInitialized.value) {
                return Column(
                    children: [
                      CameraPreview(controller.cameraController),

                      TextButton(onPressed: () {
                        controller.cameraController.takePicture().then((value) async{
                          print("value.path ${value.path}");
                          File? file = File(value.path);
                          await controller.detectimage(file);
                        });
                      }, child: Text("Capture"))

                      ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
