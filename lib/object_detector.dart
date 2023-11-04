import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'package:image_cropper/image_cropper.dart';

class ObjectDetector extends StatefulWidget {
  const ObjectDetector({super.key});

  @override
  State<ObjectDetector> createState() => _ObjectDetectortState();
}

class _ObjectDetectortState extends State<ObjectDetector>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  CameraController? _cameraController;

  final _textRecognizer = TextRecognizer();

  final ImageCropper _imageCropper = ImageCropper();

  var cameraCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
    initTflite();
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

    await _cameraController?.initialize().then((value) async {
      /* cameraCount++;
      if(cameraCount % 10 == 0) {
        cameraCount = 0; */
      await _cameraController?.startImageStream((image) {
        cameraCount++;
        if (cameraCount % 10 == 0) {
          cameraCount = 0;
          objectDetector(image);
        }
        setState(() {});
      });
      setState(() {});
      //}
    });

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    //var file;

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);

      /* File? croppedFIle = await cropImage(file);
      print("cropped image is $croppedFIle");

      final inputImage = InputImage.fromFile(croppedFIle!);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
          builder: (context) => ResultScreen(
              text: recognizedText.text,
              croppedFile: croppedFIle /* recognizedText.text */))); */
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
                  title: const Text("Object Detection"),
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

  //init tflite model
  initTflite() async {
    var res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    print("Result after loading model is $res");
  }

  // objects detection the image
  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.4,
        asynch: true);

    if (detector != null) {
      print("Result is $detector");
    }
  }
}
