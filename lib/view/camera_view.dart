import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/view_model/scan_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late ScancodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScancodeController();
    print("controller ${_controller.isCameraInitialized.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera View"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        // Other actions...
      ),
      body: GetBuilder<ScancodeController>(
        init: _controller,
        builder: (controller) {
          if (controller.isCameraInitialized.value) {
            return Column(
              children: [
                Stack(
                  children: [
                    CameraPreview(controller.cameraController),
                    Positioned(
                      top: (controller.y ?? 0.0) * 500,
                      right: (controller.x ?? 0.0) * 500,
                      child: Container(
                        width: (controller.w ?? 1.0) * 100 * context.width / 100,
                        height: (controller.h ?? 1.0) * 100 * context.height / 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Text(controller.label)),
                          ],),
                      ),
                    )
                    ]),
                // Add any additional UI components or buttons here.
              ],
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
