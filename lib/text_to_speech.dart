import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

//void main() => runApp(MyApp());

class TextTOSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Text-to-Speech Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async{
                  await speakText("Hello, I am Flutter Text-to-Speech."); // Function to start speaking
                },
                child: Text('Speak'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future speakText(String text) async {
    await flutterTts.setSpeechRate(0.0); // Set the speed of speech
    await flutterTts.setVolume(1.0); // Set the volume (0.0 to 1.0)
    await flutterTts.setPitch(1.0); // Set the pitch (1.0 is default pitch)

    await flutterTts.speak(text); // Speak the provided text
  }
}
