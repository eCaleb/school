// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({Key? key, required this.controller, this.validator})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  bool notFocused = true;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
    setState(() {
      notFocused = !hasFocus;
    });
  },
      child: TextFormField(
        style: TextStyle(color: notFocused ? Colors.black : Colors.blue),
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: notFocused ? Colors.black : Colors.blue),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: notFocused ? Colors.black : Colors.blue)),
          suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              }),
        ),
        obscureText: _obscureText,
        validator: widget.validator,
      ),
    );
  }
}
