import 'package:english_teacher/right_balloon.dart';
import 'package:english_teacher/left_balloon.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// New class definition
class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<Message> messages = []; // Changed to Message instead of String
  final TextEditingController textController = TextEditingController();

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
                isUser: false));
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
        messages.add(Message(text: text, isUser: true));
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
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  if (messages[index].isUser) {
                    return RightBalloon(message: messages[index].text);
                  } else {
                    return LeftBalloon(message: messages[index].text);
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
