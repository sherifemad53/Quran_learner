import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  stt.SpeechToText? speech;
  bool isListening = false;
  double confidence = 1.0;
  String text = "Press the Button and start speaking";

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  void listen() async {
    if (!isListening) {
      bool? available = await speech!.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        speech!.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      speech!.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confidence:  ${((confidence * 100).toStringAsFixed(1))}%',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Text(text),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: listen,
        child: Icon(isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
