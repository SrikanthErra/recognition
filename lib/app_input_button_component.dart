import 'package:flutter/material.dart';

class AppInputButtonComponent extends StatelessWidget {
  AppInputButtonComponent({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.width,
    this.height,
  });
  final void Function() onPressed;
  final String buttonText;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green
          /* gradient: LinearGradient(colors: [
            Color(0xffB81736),
            Color(0xff281637),
            /* const Color.fromARGB(255, 10, 36, 11),
            Color.fromARGB(255, 105, 103, 227),
            const Color.fromARGB(255, 10, 36, 11), */
          ]
          ) */
          ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent.withOpacity(0.1),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
