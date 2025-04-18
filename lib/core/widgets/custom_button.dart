import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool? isLoading;
  final Color bgColor;
  final Color fgColor;
  final Color borderColor;
  final String text;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final bool isPaddingActive;

  const CustomButton(
      {super.key,
      this.isLoading = false,
      required this.text,
      this.bgColor = const Color(0xFF1D4ED8),
      this.fgColor = Colors.white,
      this.borderColor = const Color(0xFF1D4ED8),
      this.onPressed,
      this.width,
      this.height = 60,
      this.isPaddingActive = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isPaddingActive ? 20.0 : 0),
      child: Container(
        width: width,
        height: (height! / MediaQuery.of(context).size.height) *
            MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return fgColor;
                }
                return bgColor;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return bgColor;
                }
                return fgColor;
              },
            ),
            elevation: WidgetStateProperty.all<double>(4.0),
            shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<WidgetState> states) {
                return RoundedRectangleBorder(
                  side: BorderSide(
                    width: 3,
                    color: borderColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                );
              },
            ),
          ),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
