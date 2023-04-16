import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LabelInputBox extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;
  final int minLines;

  const LabelInputBox({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.minLines,
    required this.maxLines,
  });

  @override
  State<LabelInputBox> createState() => _LabelInputBoxState();
}

class _LabelInputBoxState extends State<LabelInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 219, 212, 212),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        autocorrect: true,
        style: TextStyle(
          fontSize: 17,
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.placeholder,
          labelStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
