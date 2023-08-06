import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts flutterTts = FlutterTts();

  TextToSpeech() {
    flutterTts.setLanguage('en-US');
  }

  Future<void> speak(String text) async {
    if (_isJapanese(text)) {
      await flutterTts.setLanguage('ja-JP');
    } else {
      await flutterTts.setLanguage('ja-US');
    }
    await flutterTts.speak(text);
  }

  bool _isJapanese(String text) {
    // 簡易的な日本語判定を行うための正規表現
    return RegExp(r'[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}ー]').hasMatch(text);
  }
}
