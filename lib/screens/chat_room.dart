// ライブラリ
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// model
import 'package:english_teacher/models/message.dart';

// api
import 'package:english_teacher/api/post_chat.dart';

// widget
import 'package:english_teacher/widgets/right_balloon.dart';
import 'package:english_teacher/widgets/left_balloon.dart';
import 'package:english_teacher/widgets/text_input.dart';

// utils
import 'package:english_teacher/utils/custom_location.dart';
import 'package:english_teacher/utils/text_to_speech.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<Message> messages = [];
  final TextEditingController textController = TextEditingController();
  SpeechToText speechToText = SpeechToText();
  final TextToSpeech textToSpeech = TextToSpeech();
  var isListening = false;

  void handleSubmitted(String? text) async {
    if (text != null && text.isNotEmpty) {
      setState(() {
        messages.add(Message(text: text, isUser: true, time: DateTime.now()));
      });

      Message? botMessage = await postChat(text);
      if (botMessage != null) {
        setState(() {
          messages.add(botMessage);
          textToSpeech.speak(botMessage.text);
        });
      }

      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Name'),
      ),
      floatingActionButtonLocation: const CustomLocation(),
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.blue,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      textController.text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
            handleSubmitted(textController.text);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  if (messages[index].isUser) {
                    return RightBalloon(
                        message: messages[index].text,
                        time: messages[index].time);
                  } else {
                    return LeftBalloon(
                        message: messages[index].text,
                        time: messages[index].time);
                  }
                }),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextInput(
                    controller: textController,
                    onSubmitted: handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    handleSubmitted(textController.text);
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
