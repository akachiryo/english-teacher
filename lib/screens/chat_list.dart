import 'package:flutter/material.dart';
import 'chat_room.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: ListView(
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
            title: const Text('User Name'),
            subtitle: const Text('Last Message'),
            trailing: const Text('Time'),
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
      ),
    );
  }
}
