// chat_room.dart
import 'package:flutter/material.dart';
import 'text_input.dart'; // 新しく作成したファイルをインポートします。
import 'right_balloon.dart'; // RightBalloonをインポートします。
import 'left_balloon.dart'; // LeftBalloonをインポートします。

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Name'),
        ),
        body: SafeArea(
          child: Column(children: [
            const Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                children: [
                  RightBalloon(message: 'aafdsafsdafsdfsad'),
                  LeftBalloon(message: 'This is a message from LeftBalloon'),
                  RightBalloon(message: 'aafdsafsdafsfdsafdsafsaffsaffdsafsaffdfsadfsdafsaffdsfsafsdafasdfsafdasafdfsad'),
                  LeftBalloon(message: 'This is a mesfsadfaasage faaaaaaaaaaaaasfdsahfosahfhasdfghsdjfgn;fldsajsadfkrom LeftBalloon'),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextInput(// TextInputウィジェットを使用します。
                        onSubmitted: (value) {
                      // ここでテキストが提出されたときの振る舞いを定義します。
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
