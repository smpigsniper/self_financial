import 'package:flutter/material.dart';

class CustTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final double fontSize;
  const CustTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<CustTextButton> createState() => _CustTextButtonState();
}

class _CustTextButtonState extends State<CustTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}
