// right_balloon.dart
import 'package:flutter/material.dart';

class RightBalloon extends StatelessWidget {
  final String message;

  const RightBalloon({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            color: Color.fromARGB(255, 105, 187, 255),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
