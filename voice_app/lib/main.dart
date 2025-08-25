import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const VoiceApp());
}

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const VoiceHomePage(),
    );
  }
}

class VoiceHomePage extends StatefulWidget {
  const VoiceHomePage({super.key});

  @override
  State<VoiceHomePage> createState() => _VoiceHomePageState();
}

class _VoiceHomePageState extends State<VoiceHomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _status = "Mic is Closed";
  String _transcribedText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _openMic() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("Status: $status"),
      onError: (error) => debugPrint("Error: $error"),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _status = "Mic is Open";
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() {
        _status = "Mic not available";
      });
    }
  }

  void _closeMic() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _status = "Mic is Closed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isListening ? null : _openMic,
              child: const Text("Open Mic"),
            ),
            ElevatedButton(
              onPressed: _isListening ? _closeMic : null,
              child: const Text("Close Mic"),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _transcribedText.isEmpty
                      ? "Speak something..."
                      : _transcribedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
