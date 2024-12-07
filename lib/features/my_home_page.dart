import 'package:flutter/material.dart';

import '../flavors.dart';
import 'flutter_text_to_speech/text_to_speech_widget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(F.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [ElevatedButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TextToSpeechWidget()),
            );
          }, child: const Text('Text-To-Speech'))
          ],
        ),
      ),
    );
  }
}
