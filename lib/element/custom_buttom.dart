import 'package:flutter/material.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/utils.dart';

class CustomButton extends StatelessWidget {
  // Function to be called when the button is tapped
  const CustomButton({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.fullsize = false,
    this.textsize = 16.0,
    this.outlined = false,
    this.outlineColor = Colors.black,
    this.textColor = Colors.white,
    this.isEnabled = true,
    this.isLoading = false,
    this.onTap,
    this.padding = const EdgeInsets.all(10.0),
    this.loaderColor,
    this.borderRadius = 10.0,
  });

  final Widget child;
  final Color color;
  final bool fullsize;
  final double textsize;
  final bool outlined;
  final Color outlineColor;
  final Color textColor;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color? loaderColor;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final buttonBorderRadius = BorderRadius.circular(
        borderRadius); // Adjust the border radius as needed

    return SizedBox(
      width: fullsize ? double.infinity : null,
      height: 50, // Fixed height for the button
      child: outlined
          ? OutlinedButton(
              onPressed: (isEnabled && !isLoading)
                  ? onTap
                  : null, // Call the onTap function if isEnabled is true
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: buttonBorderRadius,
                  ),
                ),
                side: WidgetStateProperty.all<BorderSide>(
                  BorderSide(
                    color: outlineColor,
                  ),
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: Utils.spinkitButtons,
                    ) // Use Utils.spinkit here
                  : child,
            )
          : ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: buttonBorderRadius,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  isEnabled ? AppColors.buttonColor : AppColors.borderColor,
                ),
              ),
              onPressed: (isEnabled && !isLoading)
                  ? onTap
                  : null, // Call the onTap function if isEnabled is true
              child: isLoading
                  ? const Center(
                      child: Utils.spinkitButtons,
                    ) // Use Utils.spinkit here
                  : Padding(padding: padding, child: child),
            ),
    );
  }
}
