import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:self_financial/widget/color.dart';

class CustTextField extends StatefulWidget {
  final String text;
  final IconData? iconData;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final bool? hideText;
  final String? errorText;
  final List<TextInputFormatter>? textInputForrmaterList;
  final bool? decimalOnly;
  const CustTextField({
    Key? key,
    required this.text,
    this.iconData,
    this.controller,
    this.onChange,
    this.focusNode,
    this.hideText,
    this.errorText,
    this.textInputForrmaterList,
    this.decimalOnly,
    this.autoFocus,
  }) : super(key: key);

  @override
  State<CustTextField> createState() => _CustTextFieldState();
}

class _CustTextFieldState extends State<CustTextField> {
  final CustColors _custColors = CustColors();
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      autofocus: (widget.autoFocus == true) ? true : false,
      controller: widget.controller,
      inputFormatters: widget.textInputForrmaterList,
      keyboardType: (widget.decimalOnly == true)
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      obscureText:
          (widget.hideText == null || widget.hideText == false) ? false : true,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: _custColors.primaryColor[0]),
        labelText: widget.text,
        prefixIcon: (widget.iconData != null) ? Icon(widget.iconData) : null,
        border: const OutlineInputBorder(),
        errorText: widget.errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _custColors.primaryColor[0],
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: widget.onChange,
    );
  }
}
