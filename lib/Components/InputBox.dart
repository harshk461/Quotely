// ignore: file_names
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final bool hiddenText;
  final String placeholder;
  const InputBox(
      {super.key,
      required this.controller,
      required this.hiddenText,
      required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 1,
            color: Colors.black,
          )),
      child: TextField(
        autocorrect: false,
        obscureText: hiddenText,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
