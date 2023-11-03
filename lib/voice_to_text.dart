import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceToText extends StatefulWidget {
  VoiceToText({Key? key}) : super(key: key);

  @override
  _VoiceToTextState createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  bool _speekflag = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    requestMicrophonePermission();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      // Proceed with speech recognition functionality if initialization is successful
    } on PlatformException catch (e) {
      print("Speech recognition not available: ${e.message}");
      // Handle the error or display a message to the user
      // For example, set _speechEnabled to false and inform the user
      _speechEnabled = false;
      // Display a message indicating that speech recognition is not available
    }
    print("_speechEnabled $_speechEnabled");
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult,
    listenMode: ListenMode.dictation
    /* listenFor: Duration(hours: 1),
    pauseFor: Duration(hours: 1), */
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  /* void _onSpeechResult(SpeechRecognitionResult result) {
  setState(() {
    _lastWords = result.recognizedWords;
    if (result.finalResult) {
      print("sdsfsdfsdfsd");
      if (result.recognizedWords.isEmpty) {
        print("0000000000");
        _stopListening();
      }
    }
  });
} */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      // If listening is active show the recognized words
                      _speechToText.isListening
                          ? 'Listening'
                          // If listening isn't active but could be tell the user
                          // how to start it, otherwise indicate that speech
                          // recognition is not yet ready or not supported on
                          // the target device
                          : _speechEnabled
                              ? 'Tap the microphone to start listening...'
                              : 'Speech not available',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Words spoken are :  $_lastWords")
                  ],
                ),

                
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: 
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: _speechToText.isNotListening ? 'Start Listening' : 'Stop Listening',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  void requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    print("microphone status $status");
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (status.isGranted) {
        // Permission has been granted. Proceed with speech recognition setup.
      }
    } else {
      // Permission has already been granted. Proceed with speech recognition setup.
    }
  }
}
