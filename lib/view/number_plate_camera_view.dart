import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:text_recognition_ocr_scanner/view_model/number_plate_controller.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
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
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CameraPreview(controller.cameraController)),

                  /* RotatedBox(
                    quarterTurns: 1 -
                        controller.cameraController.description
                                .sensorOrientation ~/
                            90,
                    child: CameraPreview(controller.cameraController),
                  ), */

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amber)),
                        onPressed: () async {
                          print(
                              "orientation ${MediaQuery.of(context).orientation}");

                          controller.cameraController
                              .takePicture()
                              .then((value) async {
                            print("value.path ${value.path}");

                            File? file = File(value.path);
                            File? croppedFIle = await cropImage(file);
                            print("cropped image is $croppedFIle");
                            await controller.detectImage(croppedFIle!, context);
                          });
                        },
                        child: Text(
                          "Capture",
                          style: TextStyle(color: Colors.black),
                        )),
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
        File cropped = File(croppedFile.path);
        /* bool isPortrait = await isImagePortrait(cropped);

        if (!isPortrait) {
          File convertedFile = await convertToPortrait(cropped);
          return convertedFile;
        } else {
          return cropped;
        } */
        return cropped;
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

  Future<bool> isImagePortrait(File imageFile) async {
    // Read image using image library
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    // Check image orientation
    return image!.width <= image.height;
  }

  Future<File> convertToPortrait(File imageFile) async {
    // Read image using image library
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    // Rotate image if it's landscape to make it portrait
    img.Image convertedImage = img.copyRotate(image!, angle: -90);

    // Save the converted image and return File
    File convertedFile = File(imageFile.path);
    convertedFile.writeAsBytesSync(img.encodeJpg(convertedImage));

    return convertedFile;
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
