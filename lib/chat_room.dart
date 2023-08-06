import 'package:avatar_glow/avatar_glow.dart';
import 'package:english_teacher/right_balloon.dart';
import 'package:english_teacher/left_balloon.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime time;

  Message({required this.text, required this.isUser, required this.time});
}

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class CustomLocation extends FloatingActionButtonLocation {
  const CustomLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0;
    final fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        60.0; // Change this value to move the FAB up or down.

    return Offset(fabX, fabY);
  }
}

class _ChatRoomState extends State<ChatRoom> {
  List<Message> messages = [];
  final TextEditingController textController = TextEditingController();
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  Future<void> postChat(String text) async {
    final token = dotenv.env['MY_TOKEN'];

    var url = Uri.https("api.openai.com", "v1/chat/completions");

    try {
      final response = await http.post(
        url,
        body: convert.jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": text}
          ]
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> answer =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

        if (answer['choices'] != null && answer['choices'].isNotEmpty) {
          setState(() {
            messages.add(Message(
                text: answer['choices'][0]["message"]["content"] ?? '',
                isUser: false,
                time: DateTime.now()));
          });
        }
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error posting chat: $e");
    }
  }

  void handleSubmitted(String? text) {
    if (text != null && text.isNotEmpty) {
      setState(() {
        messages.add(Message(text: text, isUser: true, time: DateTime.now()));
        postChat(text);
        textController.clear();
      });
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

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) onSubmitted;

  const TextInput(
      {Key? key, required this.controller, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
