import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final Function(String) onSubmitted;

  const TextInput({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
