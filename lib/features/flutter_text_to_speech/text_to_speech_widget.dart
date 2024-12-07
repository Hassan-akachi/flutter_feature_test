// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:flutter_feature_test/features/flutter_text_to_speech/tts_constant.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Import flavors configuration
import '../../flavors.dart';

// Define the TextToSpeechWidget class
class TextToSpeechWidget extends StatefulWidget {
  const TextToSpeechWidget({super.key});

  @override
  State<TextToSpeechWidget> createState() => _TextToSpeechWidgetState();
}

// Define the _TextToSpeechWidgetState class
class _TextToSpeechWidgetState extends State<TextToSpeechWidget> {
  // Initialize the FlutterTTS instance
  FlutterTts flutterTTS = FlutterTts();

  // Define variables to store the list of voices, current voice, and current word indices
  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;

  int? lastWordStart;
  int? lastWordEnd;

  bool isJustStarting = true;

  double volumeRange = 0.5;
  double pitchRange = 1;
  double speechRange = 0.5;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    print('innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnit${_currentWordStart}');
    // Initialize the TTS engine
    initTTS();
  }

  // Initialize the TTS engine
  void initTTS() {
    // Set the progress handler only when _currentWordStart is null
    if (_currentWordStart == null) {
      flutterTTS.setProgressHandler((text, start, end, word) {
        setState(() {
          _currentWordStart = start;
          _currentWordEnd = end;
        });
        print('Progress Updated: Start = $start, End = $end');
      });
    }

    // Get the list of available voices
    flutterTTS.getVoices.then((data) {
      try {
        // Convert the voice data to a list of maps
        _voices = List<Map>.from(data);

        // Filter the voices to only include English voices
        setState(() {
          _voices =
              _voices.where((_voice) => _voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  // Set the current voice
  void setVoice(Map voice) {
    // Set the voice using the FlutterTTS instance
    flutterTTS.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  stop() async {
    await flutterTTS.stop();
    isSpeaking = false;
    setState(() {
      _currentWordStart = 0;
      _currentWordEnd = 0;
    });
  }

  pause() async {
    lastWordStart = _currentWordStart;
    lastWordEnd = _currentWordEnd;
    await flutterTTS.pause();
    isSpeaking = false;
    print('Paused at: $lastWordStart, $lastWordEnd');
  }

  volume(val) async {
    volumeRange = val;
    await flutterTTS.setVolume(volumeRange);
    setState(() {});
  }

  pitch(val) async {
    pitchRange = val;
    await flutterTTS.setPitch(pitchRange);
    setState(() {});
  }

  speech(val) async {
    speechRange = val;
    await flutterTTS.setSpeechRate(speechRange);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI
    return Scaffold(
      body: buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Speak the text when the button is pressed
          _currentWordStart =20;
          flutterTTS.speak(tts_input);
          print('whhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh${_currentWordStart}');
        },
        child: Icon(Icons.play_arrow, color: F.themeColor),
      ),
    );
  }

  // Build the UI
  buildUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          RichText(
            // Aligns the text to the center of the container or parent widget.
            textAlign: TextAlign.center,

            text: TextSpan(
              // Sets the default style for the entire text (unless overridden in individual TextSpan children).
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
              children: <TextSpan>[
                // First part: Text before the highlighted word.
                TextSpan(
                  text: tts_input.substring(0, _currentWordStart), // Extracts text from the start up to the highlight.
                  style: const TextStyle(
                    color: Colors.black, // Default black color for unhighlighted text.
                  ),
                ),

                // Second part: Highlighted word (if _currentWordStart is not null).
                if (_currentWordStart != null)...[
                  TextSpan(
                    text: tts_input.substring(
                      _currentWordStart!, // Starting index of the highlighted word.
                      _currentWordEnd,    // Ending index of the highlighted word.
                    ),
                    style: TextStyle(
                      color: Colors.black, // Keeps the text color black.
                      backgroundColor: F.themeColor, // Applies a background color to highlight the word.
                    ),
                  ),
                  // Debugging print for highlighted text
                  TextSpan(
                    text: (() {
                      final debugText = tts_input.substring(
                        _currentWordStart!,
                        _currentWordEnd,
                      );
                      print("Highlighted Text: '$debugText'hhhhhhhhhhhhhhhhhhh $_currentWordStart");
                      return ""; // No visible output, just a side-effect of debugging
                    })(),
                  ),
],
                // Third part: Text after the highlighted word (if _currentWordEnd is not null).
                if (_currentWordEnd != null)
                  TextSpan(
                    text: tts_input.substring(
                      _currentWordEnd!, // Extracts the remaining text starting from the end of the highlighted word.
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _speakerSelector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  splashRadius: 40,
                  onPressed: () {
                    flutterTTS.speak(tts_input);
                  },
                  color: Colors.teal,
                  iconSize: 60,
                  icon: const Icon(Icons.play_circle)),
              IconButton(
                  onPressed: stop,
                  color: Colors.red,
                  splashRadius: 40,
                  iconSize: 60,
                  icon: const Icon(Icons.stop_circle)),
              IconButton(
                  onPressed: pause,
                  color: Colors.amber.shade700,
                  splashRadius: 40,
                  iconSize: 60,
                  icon: const Icon(Icons.pause_circle)),
            ],
          ),
          Slider(
            max: 1,
            value: volumeRange,
            onChanged: (value) {
              volume(value);
            },
            divisions: 10,
            label: "Volume: $volumeRange",
            activeColor: Colors.red,
          ),
          const Text('Set Volume'),
          Slider(
            max: 2,
            value: pitchRange,
            onChanged: (value) {
              pitch(value);
            },
            divisions: 10,
            label: "Pitch Rate: $pitchRange",
            activeColor: Colors.teal,
          ),
          const Text('Set Pitch'),
          Slider(
            max: 1,
            value: speechRange,
            onChanged: (value) {
              speech(value);
            },
            divisions: 10,
            label: "Speech rate: $speechRange",
            activeColor: Colors.amber.shade700,
          ),
          const Text('Set Speech Rate'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // Build the speaker selector dropdown
  Widget _speakerSelector() {
    return DropdownButton(
      value: _currentVoice,
      items: _voices
          .map((_voice) =>
              DropdownMenuItem(value: _voice, child: Text(_voice["name"])))
          .toList(),
      onChanged: (value) {
        setState(() {
          _currentVoice = value;
          // Update the voice in the TTS engine
          setVoice(_currentVoice!);
        });
      },
    );
  }
}
