import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_recognition_ocr_scanner/view/ScreenArguments.dart';

class NumberPlateText extends StatelessWidget {
  NumberPlateText({
    super.key,
  });
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ScreenArguments;

    String inputString = args.numberPlateText;
    String result = extractStartsWithTS(inputString);
    print(result);
    return Scaffold(
      appBar: AppBar(
        title: const Text("NumberPlateText"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            print("Back button pressed");
            try {
              print("Stop speaking");
              stopSpeaking();
              Navigator.pop(context);
            } catch (e) {
              print("Error in onPressed: $e");
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(result)),
                    GestureDetector(
                      onTap: () async {
                        await speakText(result); // Function to start speaking
                      },
                      child: Icon(
                        Icons.keyboard_voice_outlined,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Image.file(
                  args.Image,
                  height: 320,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future speakText(String text) async {
    await flutterTts.setSpeechRate(0.5); // Set the speed of speech
    await flutterTts.setVolume(1.0); // Set the volume (0.0 to 1.0)
    await flutterTts.setPitch(1.0); // Set the pitch (1.0 is default pitch)

    await flutterTts.speak(text); // Speak the provided text
  }

  void stopSpeaking() {
    print("Stop speaking method called");
    flutterTts.stop(); // Stop the speech
  }

  /* String extractStartsWithTS(String input) {
    String search = 'TS';
    int index = input.indexOf(search);
    if (index != -1) {
      String substr = input.substring(index);

      // Remove special characters using regex
      substr = substr.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

      return substr;
    }
    return '';
  } */

  String extractStartsWithTS(String input) {
    /* int tsIndex = input.indexOf('TS');

  if (tsIndex != -1) {
    String substr = input.substring(tsIndex); */
    String substr = input;

    // Remove 'TND' and 'IND' from the substring
    substr = substr.replaceAll('TND', '').replaceAll('IND', '');

    // Remove special characters except spaces using regex
    substr = substr.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    return substr;
    /* }
  return ''; */
  }
}
