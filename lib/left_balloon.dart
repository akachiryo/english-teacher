import 'package:flutter/material.dart';

class LeftBalloon extends StatelessWidget {
  final String message;

  const LeftBalloon({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Row(
        children: [
          const CircleAvatar(
            // アバターアイコンを追加します。
            backgroundImage: AssetImage('assets/images/sample_avatar.png'),
            radius: 20, // アバターの大きさを調整します。適切な値を設定してください。
          ),
          const SizedBox(width: 10), // アバターアイコンとバルーンの間にスペースを設けます。
          Expanded(
            // Expandedを使って、アバター以外のスペースをバルーンが使用できるようにします。
            child: Align(
              alignment: Alignment.centerLeft,
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
          ),
        ],
      ),
    );
  }
}
