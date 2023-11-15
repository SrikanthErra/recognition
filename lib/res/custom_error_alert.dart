import 'package:flutter/material.dart';
import 'package:text_recognition_ocr_scanner/res/app_constants.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';

class CustomErrorAlert extends StatefulWidget {
  final String descriptions;
  final String? Buttontext;
  final String? Img;
  final Color? imagebg;
  final Color? bgColor;
  final void Function()? onPressed;

  const CustomErrorAlert({
    Key? key,
    required this.descriptions,
    this.Buttontext,
    required this.onPressed,
    this.bgColor,
    this.Img,
    this.imagebg,
  }) : super(key: key);

  @override
  _CustomErrorAlertState createState() => _CustomErrorAlertState();
}

class _CustomErrorAlertState extends State<CustomErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 10),
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Version: ${AppConstants.version_number}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Object Detection",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  /* width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.07, */

                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: widget.bgColor != null
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: widget.bgColor,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(colors: [
                            const Color.fromARGB(255, 142, 69, 64),
                            Colors.red
                          ])),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: widget.onPressed,
                    child: Text(
                      widget.Buttontext ?? "Ok",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CircleAvatar(
              backgroundColor: widget.imagebg ?? Colors.white,
              radius: 35,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  child: Image.asset(
                    widget.Img ?? AssetPath.cross,
                    fit: BoxFit.cover,
                  )
                  /* AssetImage(
                    path
                    widget.Img ?? AssetPath.cross,
                    fit: BoxFit.cover,
                  ) */
                  ),
              /* Image.asset(
                    widget.Img,
                    // width: 100, height: 100,
                    fit: BoxFit.cover,
                  )), */
            ),
          ),
        ),
      ],
    );
  }
}
