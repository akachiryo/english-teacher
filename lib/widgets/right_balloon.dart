import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RightBalloon extends StatelessWidget {
  final String message;
  final DateTime time;

  const RightBalloon({Key? key, required this.message, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Text(timeFormat.format(time),
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
              color: Color.fromARGB(255, 105, 187, 255),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(message),
            ),
          ),
        ],
      ),
    );
  }
}
