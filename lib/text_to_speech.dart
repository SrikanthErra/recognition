import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  @override
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    print("Dispose method called");
    flutterTts.stop(); // Stop speech when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Text-to-Speech Example'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          icon: Icon(Icons.arrow_forward_ios),
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
    print("Stop speaking method called");
    flutterTts.stop(); // Stop the speech
  }
}
