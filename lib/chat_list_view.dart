import 'package:flutter/material.dart';
import 'chat_room.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatRoom(),
            ));
          },
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/sample_avatar.png'),
          ),
          title: Text('User Name'),
          subtitle: Text('Last Message'),
          trailing: Text('Time'),
        ),
        const ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/sample_avatar.png'),
          ),
          title: Text('User Name'),
          subtitle: Text('Last Message'),
          trailing: Text('Time'),
        ),
      ],
    );
  }
}
