import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylelezza/element/custom_text.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    this.svgImage,
    this.onTap,
    required this.backgroundColor,
    required this.borderRadius,
    this.padding = const EdgeInsets.all(0),
    required this.labelColor,
    required this.labelFontWeight,
    required this.labelFontSize,
    this.svgColor,
    this.isSelected = false,
    this.border,
  });

  final String label;
  final String? svgImage;
  final Border? border;
  final Color backgroundColor;
  final double borderRadius;

  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color labelColor;
  final FontWeight labelFontWeight;
  final double labelFontSize;
  final Color? svgColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
            border: border),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (svgImage != null) ...[
                SvgPicture.asset(
                  svgImage!,
                  height: 20,
                  width: 20,
                  color: svgColor,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
              CustomText(
                textAlign: TextAlign.center,
                text: label,
                color: labelColor,
                fontWeight: labelFontWeight,
                size: labelFontSize,
              ),
              if (isSelected && label != 'All') ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.cancel,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
