import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:text_recognition_ocr_scanner/app_input_button_component.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:text_recognition_ocr_scanner/model/moduels_model.dart';
import 'package:text_recognition_ocr_scanner/res/app_constants.dart';
import 'package:text_recognition_ocr_scanner/res/custom_warning_alert.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';
import 'package:text_recognition_ocr_scanner/view/sidemenu_view.dart';

class Recognition extends StatefulWidget {
  const Recognition({super.key});

  @override
  State<Recognition> createState() => _RecognitionState();
}

class _RecognitionState extends State<Recognition> {
  List<ModulesModel> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    loadModules();
  }

  loadModules() async {
    items.add(ModulesModel(
      imagePath: AssetPath.image_to_text,
      moduleName: "IMAGE TO TEXT",
      routeName: AppRoutes.ImageToText,
    ));
    items.add(ModulesModel(
      imagePath: AssetPath.voice_to_text,
      moduleName: "VOICE TO TEXT",
      routeName: AppRoutes.VoiceToText,
    ));
    items.add(ModulesModel(
      imagePath: AssetPath.object,
      moduleName: "OBJECT DETECTION",
      routeName: AppRoutes.CameraView,
    ));
    items.add(ModulesModel(
      imagePath: AssetPath.license_plate,
      moduleName: "NUMBER PLATE DETECTION",
      routeName: AppRoutes.NumberPlateCameraView,
    ));

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConstants.version_number = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 2, 20, 69),
          height: MediaQuery.of(context).size.height * 0.06,
          child: Image.asset(
            AssetPath.footer_png,
            width: double.infinity,
          ),
        ),
        drawer: SideMenuView(),
        appBar: AppBar(
          title: Text('Dashboard', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 2, 20, 69),
          leading: Builder(
            builder: (BuildContext innerContext) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  // Open the drawer using the inner context
                  Scaffold.of(innerContext).openDrawer();
                },
              );
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPath.bg), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Lets begin with setting",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("a new AI goal!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("—",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ListView(
                shrinkWrap: true,
                //mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2, // Adjust the crossAxisCount as per your needs
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: (.5 / .5),
                      ),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          child: GridTile(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, items[index].routeName ?? '');
                                },
                                child: Card(
                                  shadowColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    //side: BorderSide(width: 5, color: Colors.green)
                                  ),
                                  color: Colors.white,
                                  elevation: 10,
                                  //surfaceTintColor: Colors.red,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      /* Image.network(
                                items[index].imagePath ?? '',
                                height: 50.0,
                                width: 50.0,
                              ), */
                                      Image.asset(
                                        items[index].imagePath ?? '',
                                        height: 70.0,
                                        width: 70.0,
                                        //color: AppColors.backgroundClr,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        items[index].moduleName ?? '',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /* AppInputButtonComponent(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.ImageToText);
                      },
                      buttonText: "Image To Text"),
                  SizedBox(
                    height: 20,
                  ),
                  AppInputButtonComponent(
                      onPressed: () async {
                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                        AndroidDeviceInfo androidInfo =
                            await deviceInfo.androidInfo;
                        print("deviceInfo ${androidInfo.supportedAbis}");
                        print("5678678");
                        Navigator.pushNamed(context, AppRoutes.VoiceToText);
                      },
                      buttonText: "Voice To Text"),
                  SizedBox(
                    height: 20,
                  ),
                  AppInputButtonComponent(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.CameraView);
                      },
                      buttonText: "Object Detection"),
                  SizedBox(
                    height: 20,
                  ),
                  AppInputButtonComponent(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.NumberPlateCameraView);
                      },
                      buttonText: "Number Plate Detection"), */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
