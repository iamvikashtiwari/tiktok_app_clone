import 'package:flutter/material.dart';
import 'package:tiktok_app_clone/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isObscure;
  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 25),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
