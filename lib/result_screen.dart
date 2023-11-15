import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_recognition_ocr_scanner/res/image_constants.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  final File? croppedFile;
  ResultScreen({super.key, required this.text, this.croppedFile});
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Color.fromARGB(255, 2, 20, 69),
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
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPath.bg), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      text,
                      style: TextStyle(
                          color: Colors.white),
                    )),
                    GestureDetector(
                      onTap: () async {
                        await speakText(text); // Function to start speaking
                      },
                      child: Icon(
                        Icons.keyboard_voice_outlined,
                        color: Colors.green,
                        size: 40,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Image.file(
                  croppedFile!,
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
}
