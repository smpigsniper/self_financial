import 'package:flutter/material.dart';
import 'package:self_financial/widget/color.dart';
import 'package:self_financial/widget/font_size.dart';

class CustElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  const CustElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustElevatedButton> createState() => _CustElevatedButtonState();
}

class _CustElevatedButtonState extends State<CustElevatedButton> {
  final CustColors _custColor = CustColors();
  final CustFontSize _custFontSize = CustFontSize();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _custColor.primaryColor[0],
        foregroundColor: _custColor.primaryColor[0],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      focusNode: widget.focusNode,
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
            color: _custColor.textColor[1],
            fontSize: _custFontSize.primaryFontSize[6]),
      ),
    );
  }
}
