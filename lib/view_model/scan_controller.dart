import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ScancodeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  //late CameraImage cameraImage;
  var cameraCount = 0;

  var isCameraInitialized = false.obs; //obs ----. observable

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController =
          await CameraController(cameras[0], ResolutionPreset.max);

      await cameraController.initialize();
      isCameraInitialized(true); //isCameraInitialized.value = true;
      update();
      /* await cameraController.startImageStream((image) async{
          cameraCount++;
          print("cameraCount----- $cameraCount");
          print("image $image");
          if (cameraCount % 1 == 0) {
            cameraCount = 0;
            await objectDetector(image);
            print("isCameraInitialized $isCameraInitialized");
          }
          update();
        }); */


      /* cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
        /* cameraCount++;
        if (cameraCount % 10 == 0) {
          cameraCount = 0;
          cameraController.startImageStream((image) => objectDetector(image));
          update();
        } */
      }); */
    } else {
      await Permission.camera.request();
    }
  }

  initTFLite() async {
    var res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    print("result is $res");
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
       // numResults: 1,
        threshold: 0.4,
        asynch: true);

    if (detector != null) {
      print("Result is $detector");
    }
  }


  Future detectimage(File image) async {
    print("image path is ${image.path}");
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      //numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print("_recognitions is $recognitions");
    update();
    /* setState(() {
      _recognitions = recognitions;
      print("_recognitions is $recognitions");
      v = recognitions.toString();
      // dataList = List<Map<String, dynamic>>.from(jsonDecode(v));
    }); */
    print("//////////////////////////////////////////////////");
    print(recognitions);
    // print(dataList);
    print("//////////////////////////////////////////////////");
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }
}
