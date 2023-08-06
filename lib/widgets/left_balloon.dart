// left_balloon.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeftBalloon extends StatelessWidget {
  final String message;
  final DateTime time;

  const LeftBalloon({Key? key, required this.message, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // <-- Align at the bottom
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/sample_avatar.png'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Flexible( // <-- Wrap message with Flexible
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Color.fromARGB(255, 233, 233, 233),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(message),
              ),
            ),
          ),
          const SizedBox(width: 10), // <-- Add space between balloon and time
          Text(timeFormat.format(time), style: const TextStyle(fontSize: 15)), // <-- Move time to the right of balloon
        ],
      ),
    );
  }
}

