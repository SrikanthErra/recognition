import 'package:flutter/material.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_ocr_scanner/view_model/side_menu_viewmodel.dart';
import 'package:flutter_svg/svg.dart';

class SideMenuView extends StatefulWidget {
  const SideMenuView({
    Key? key,
  }) : super(key: key);
  @override
  State<SideMenuView> createState() => _SideMenuViewState();
}

class _SideMenuViewState extends State<SideMenuView> {
  List<Map<String, dynamic>> subtitleGroups = [
    /* {
      'title': '',
      'subtitles': [
        {'title': 'Home', 'image': AssetPath.home},
      ],
    }, */
    {
      'title': 'Modules',
      'subtitles': [
        {'title': 'Image to Text', 'image': AssetPath.image_to_text},
        {'title': 'Voice to Text', 'image': AssetPath.voice_to_text},
        {'title': 'Object Detection', 'image': AssetPath.object},
        {'title': 'Number Plate Detection', 'image': AssetPath.license_plate},
      ],
    },
    {
      'title': 'Info',
      'subtitles': [
        {'title': 'Privacy Policy', 'image': AssetPath.privacy},
        {'title': 'App Info', 'image': AssetPath.appinfo}
      ],
    },
    {
      'title': 'Others',
      'subtitles': [
        {'title': 'Exit application', 'image': AssetPath.exit},
        {'title': 'Logout', 'image': AssetPath.logout},
      ],
    },
  ]; // Define the subtitle groups as a list of maps
  List<Map<String, dynamic>> subtitles = [];

  String? ImagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuViewModel>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              //height: 30.h,
              child: Image.asset(AssetPath.app_logo, fit: BoxFit.fill),
              /* Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      /* width: 80.w,
                      height: 22.h, */
                      child: Image.asset(AssetPath.tsfire_logo, fit: BoxFit.cover),
                      
                      ),
                  SizedBox(
                    height: 5.0,
                  ),
                  /* Text('${widget.employeeName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white)), */
                ],
              ), */
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                itemCount: subtitleGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  String groupTitle = subtitleGroups[index]['title'];
                  List<Map<String, dynamic>> subtitles =
                      subtitleGroups[index]['subtitles'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (groupTitle != 'Modules' && groupTitle != ' ') ...{
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Text(
                            groupTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black45),
                          ),
                        ),
                        Column(
                          children: subtitles.map((subtitle) {
                            return ListTile(
                              leading: SvgPicture.asset(
                                subtitle['image'],
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                subtitle['title'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              onTap: () {
                                sideMenuProvider.navigationTo(
                                    context, subtitle['title']);
                              },
                            );
                          }).toList(),
                        ),
                      } else if (groupTitle == ' ') ...{
                        Column(
                          children: subtitles.map((subtitle) {
                            return ListTile(
                              leading: Image.asset(
                                subtitle['image'],
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                subtitle['title'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              onTap: () {
                                sideMenuProvider.navigationTo(
                                    context, subtitle['title']);
                              },
                            );
                          }).toList(),
                        ),
                      },
                      if (groupTitle == 'Modules') ...{
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Text(
                            groupTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black45),
                          ),
                        ),
                        Column(
                          children: subtitles.map((subtitle) {
                            return ListTile(
                              leading: Image.asset(
                                subtitle['image'],
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                subtitle['title'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              onTap: () {
                                sideMenuProvider.navigationTo(
                                    context, subtitle['title']);
                              },
                            );
                          }).toList(),
                        ),
                      },
                      Divider()
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
