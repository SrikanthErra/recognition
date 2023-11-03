import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_pages.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/cropped_cameraview.dart';
import 'package:text_recognition_ocr_scanner/result_screen.dart';

import 'package:image_cropper/image_cropper.dart';




class ImageToText extends StatefulWidget {
  const ImageToText({super.key});

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  CameraController? _cameraController;

  final _textRecognizer = TextRecognizer();

  final ImageCropper _imageCropper = ImageCropper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (CameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    //Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  /* Future<void> _scanImage() async {
  if (_cameraController == null) return;
  final navigator = Navigator.of(context);

  try {
    final pictureFile = await _cameraController!.takePicture();
    /* if (pictureFile != null && pictureFile.path.isNotEmpty) {
      final croppedFile = await crop(file: pictureFile);

      if (croppedFile != null) {
        final file = File(croppedFile.path);
        final inputImage = InputImage.fromFile(file);
        final recognizedText = await _textRecognizer.processImage(inputImage);
        if (recognizedText != null) {
          await navigator.push(MaterialPageRoute(
            builder: (context) => ResultScreen(text: recognizedText.text),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Text recognition failed. Please try again."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred while cropping the image"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while capturing the image"),
        ),
      );
    } */
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("An error occurred while scanning text"),
      ),
    );
  }
} */

  /* Future<void> _scanImage() async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    //var file;

    try {
      final pictureFile = await _cameraController!.takePicture();
   
      /* if(pictureFile.path.isNotEmpty) {
        final croppedFile = await crop(file: pictureFile,
        //cropStyle: CropStyle.circle
        );

        if(croppedFile != null) {
          setState(() {
            file = File(croppedFile.path);
          });
        }
      } */


    final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
          builder: (context) => ResultScreen(text: recognizedText.text)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An error occurred while scanning text")));
    }
  } */

  /* Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final cropIMage = await _imageCropper.cropImage(
      cropStyle: cropStyle,
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      /* compressQuality: 100,
      uiSettings: [
        IOSUiSettings(),
        AndroidUiSettings()
      ], */
    );
    return cropIMage;
  } */

  /* Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final croppedFile = await _imageCropper.cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: cropStyle,
    );
    return croppedFile;
  } */

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

  Future<void> _scanImage() async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    //var file;

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);

      File? croppedFIle = await cropImage(file);
      print("cropped image is $croppedFIle");

      final inputImage = InputImage.fromFile(croppedFIle!);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
          builder: (context) => ResultScreen(
              text: recognizedText.text,
              croppedFile: croppedFIle /* recognizedText.text */)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An error occurred while scanning text")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _initCameraController(snapshot.data!);
                      return Center(
                        child:
                            //CroppedCameraPreview(cameraController: _cameraController!,)
                            CameraPreview(_cameraController!),
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
              Scaffold(
                appBar: AppBar(
                  title: const Text("Text Recognition Sample"),
                ),
                backgroundColor:
                    _isPermissionGranted ? Colors.transparent : null,
                body: _isPermissionGranted
                    ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            //color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.amber)),
                                    onPressed: () async {
                                      await _scanImage();
                                    },
                                    child: Text(
                                      "Scan Text",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Text(
                            "Camera Permission denied",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              )
            ],
          );
        });
  }

  // cropping the image
}
