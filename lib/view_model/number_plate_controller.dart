import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/result_screen.dart';
import 'package:text_recognition_ocr_scanner/view/ScreenArguments.dart';
import 'package:tflite_v2/tflite_v2.dart';

class NumberPlateController extends GetxController {
  // Other existing code remains unchanged...

  late bool isDetectingObjects;
  late bool isCameraStreaming;
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late RecognizedText recognizedText;
  final _textRecognizer = TextRecognizer();
  var cameraCount = 0;

  var isCameraInitialized = false.obs; //obs ----. observable

  var x, y, w, h = 0.0;
  var label = '';

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
    isDetectingObjects = false;
    isCameraStreaming = false;
  }

  // Existing code for initCamera and initTFLite remains the same...

  Future<void> detectImage(File image, context) async {
    if (isDetectingObjects) {
      return;
    }
    isDetectingObjects = true;

    try {
      EasyLoading.show(status: 'loading...');
      var detector = await Tflite.detectObjectOnImage(
        path: image.path,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      print("Detector result: $detector");

      if (detector != null && detector.isNotEmpty) {
        var detectedObject = detector.first;
        if (detectedObject['confidenceInClass'] > 0.9) {
          x = detectedObject['rect']['x'];
          y = detectedObject['rect']['y'];
          w = detectedObject['rect']['w'];
          h = detectedObject['rect']['h'];
          label = detectedObject['detectedClass'].toString();
          print("label is $label");

          //text recognition
          final inputImage = InputImage.fromFile(image);
          recognizedText = await _textRecognizer.processImage(inputImage);

          print("recognizedText.text ${recognizedText.text}");
          EasyLoading.dismiss();
          await Navigator.pushNamed(context, AppRoutes.NumberPlateText,
              arguments: ScreenArguments(recognizedText.text, image));

          //await Navigator.pushNamed(context, AppRoutes.);
        }
        update(); // Ensure the UI updates after getting the detection results.
      } else {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("No Number Plate Detected"),
                  content: Text("Please try again"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"))
                  ],
                ));
      }
    } catch (e) {
      print("Error in object detection: $e");
    }

    isDetectingObjects = false;
  }

  initTFLite() async {
    var res = await Tflite.loadModel(
        model: "assets/detect_2.tflite",
        labels: "assets/labels_2.pbtxt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    print("result is $res");
  }

  Future<void> initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(cameras[0], ResolutionPreset.max);

      try {
        await cameraController.initialize();
        //SystemChrome.setPreferredOrientations([cameraController.value.deviceOrientation]);
        isCameraInitialized(true);
        update();
        isCameraStreaming = true;
        /* await cameraController.startImageStream((image) {
          if (isCameraStreaming) {
            cameraCount++;
            if (cameraCount % 10 == 0) {
              cameraCount = 0;
              detectimage(image);
            }
          }
        }); */
      } catch (e) {
        print("Error initializing camera: $e");
        // Handle camera initialization error.
      }
    } else {
      await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isCameraStreaming = false; // Stop streaming before disposing.
    cameraController.stopImageStream();
    cameraController.dispose();
    //Tflite.close(); // Close the TFLite interpreter when not in use.
  }
}
