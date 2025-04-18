import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String fontFamily;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPaddingActive;
  final FloatingLabelBehavior floatingLabelBehavior;
  final double labelFontSize;
  final int? maxLines;
  final bool readOnly;
  final Widget? suffixIcon;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.label,
      this.fontFamily = 'Poppins',
      this.keyboardType = TextInputType.text,
      this.validator,
      this.inputFormatters,
      this.isPaddingActive = true,
      this.floatingLabelBehavior = FloatingLabelBehavior.never,
      this.labelFontSize = 16.0,
      this.maxLines,
      this.readOnly = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isPaddingActive == true ? 20.0 : 0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(5), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.2), // Softer shadow for a clean look
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2), // Position shadow for depth
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          focusNode: readOnly == false ? focusNode : AlwaysDisabledFocusNode(),
          style: const TextStyle(
            fontSize: 16.0,
            decoration: TextDecoration.none,
          ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey,
                fontFamily: fontFamily,
                fontSize: labelFontSize,
              ),
              floatingLabelBehavior: floatingLabelBehavior,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              suffixIcon: suffixIcon),
          cursorColor: Theme.of(context).colorScheme.onSurface,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          readOnly: readOnly,
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
