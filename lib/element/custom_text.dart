import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  final bool isOutlined;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final int? maxline;
  const CustomText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 14.0,
      this.fontWeight = FontWeight.normal,
      this.isOutlined = false,
      this.textAlign = TextAlign.left,
      this.textOverflow = TextOverflow.visible,
      this.textDecoration,
      this.textDecorationColor, this.maxline});

  @override
  Widget build(BuildContext context) {
    return isOutlined
        ? Stack(
            children: [
              Text(
                text,
                textAlign: textAlign,
                maxLines: maxline,
                style: GoogleFonts.publicSans(
                    color: color,
                    fontSize: size,
                    fontWeight: fontWeight,
                    decorationColor: textDecorationColor,
                    decoration: textDecoration),
                overflow: textOverflow,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 2.0,
                  color: color,
                ),
              ),
            ],
          )
        : Text(
            text,
            textAlign: textAlign,
            style: GoogleFonts.publicSans(
                color: color,
                fontSize: size,
                fontWeight: fontWeight,
                decorationColor: textDecorationColor,
                decoration: textDecoration),
            overflow: textOverflow,
          );
  }
}
