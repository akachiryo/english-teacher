import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:english_teacher/models/message.dart';

Future<Message?> postChat(String text) async {
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
        return Message(
            text: answer['choices'][0]["message"]["content"] ?? '',
            isUser: false,
            time: DateTime.now());
      }
    } else {
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("Error posting chat: $e");
  }

  return null;
}
