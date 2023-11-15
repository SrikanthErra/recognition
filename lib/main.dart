
import 'package:flutter/material.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_pages.dart';
import 'package:text_recognition_ocr_scanner/Routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_ocr_scanner/view_model/side_menu_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(
            create: (context) => SideMenuViewModel(),
          )
        ],
      child: MaterialApp(
        title: 'Flutter Text Recognition',
        initialRoute: AppRoutes.initial,
          routes: AppPages.routes,
          debugShowCheckedModeBanner: false,
          /* theme: ThemeData(
            primarySwatch: AppColors.navy,
          ), */
          //home: SideMenu(),
          builder: EasyLoading.init(),
        /* theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ), */
        //home: const MyHomePage(),
      ),
    );
  }
}

