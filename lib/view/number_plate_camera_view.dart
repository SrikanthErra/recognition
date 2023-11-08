import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/result_screen.dart';
import 'package:text_recognition_ocr_scanner/view_model/number_plate_controller.dart';
import 'package:text_recognition_ocr_scanner/view_model/scan_controller.dart';

class NumberPlateCameraView extends StatefulWidget {
  const NumberPlateCameraView({Key? key}) : super(key: key);

  @override
  _NumberPlateCameraViewState createState() => _NumberPlateCameraViewState();
}

class _NumberPlateCameraViewState extends State<NumberPlateCameraView> {
  late NumberPlateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NumberPlateController();
    print("controller ${_controller.isCameraInitialized.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Number Plate Detectioon"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        // Other actions...
      ),
      body: GetBuilder<NumberPlateController>(
        init: _controller,
        builder: (controller) {
          if (controller.isCameraInitialized.value) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                children: [
                  CameraPreview(controller.cameraController),

                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          controller.cameraController
                              .takePicture()
                              .then((value) async {
                            print("value.path ${value.path}");

                            File? file = File(value.path);
                            File? croppedFIle = await cropImage(file);
                            print("cropped image is $croppedFIle");
                            await controller.detectImage(croppedFIle!, context);

                            await navigator?.push(MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                    text: controller.recognizedText.text,
                                    croppedFile: croppedFIle  /* recognizedText.text */)));
                          });
                        },
                        child: Text("Capture")),
                  ),
                  // Add any additional UI components or buttons here.
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<File?> cropImage(File? image) async {
    if (image == null) {
      // Handle null image scenario
      return null;
    }

    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
        // Handle the case when the cropping operation fails
        return null;
      }
    } catch (e) {
      // Handle any potential exceptions during cropping
      print("Error while cropping: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Ensure proper disposal of the controller.
    super.dispose();
  }
}


/* class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Camera View"),
          leading: IconButton(
              onPressed: () {
                
                Navigator.pushNamed(context, AppRoutes.Recognition);
                ScancodeController().dispose();
              },
              icon: Icon(
                Icons.arrow_back,
                //color: AppColors.textcolorwhite,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  
                  Navigator.pushNamed(context, AppRoutes.Recognition);
                  ScancodeController().dispose();
                  //ProviderForPropertyTax.navigate(context, AppRoutes.dashboard);
                },
                icon: Icon(
                  Icons.home,
                  //color: AppColors.textcolorwhite,
                ))
          ],
        ),
        body: GetBuilder<ScancodeController>(
            init: ScancodeController(),
            builder: (controller) {
              print(
                  "isCameraInitialized ${controller.isCameraInitialized.value}");
              if (controller.isCameraInitialized.value) {
                return Column(children: [
                  CameraPreview(controller.cameraController),

                  /* TextButton(onPressed: () {
                        controller.cameraController.takePicture().then((value) async{
                          print("value.path ${value.path}");
                          File? file = File(value.path);
                          //await controller.detectimage(file);
                        });
                      }, child: Text("Capture")) */
                ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
} */
