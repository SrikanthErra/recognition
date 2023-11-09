import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class TextToSpeech extends StatefulWidget {
  @override
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop(); // Stop speech when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text-to-Speech Example'),
        leading: IconButton(
          onPressed: () {
            stopSpeaking(); // Stop speaking when back button is pressed
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await speakText("Hello, I am Flutter Text-to-Speech.");
              },
              child: Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }

  Future speakText(String text) async {
    await flutterTts.setSpeechRate(0.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(text);
  }

  void stopSpeaking() {
    flutterTts.stop(); // Stop the speech
  }
}
