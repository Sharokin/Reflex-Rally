import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBorderColor extends StatelessWidget {
  const TextBorderColor({required this.text, required this.size, required this.color, required this.outlineColor, this.fontWeight, this.textAlign}) : super();

  final String text;
  final double size;

  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  final Color color;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.bangers(
            fontSize: size,
            fontWeight: fontWeight,
            letterSpacing: 5,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round
              ..strokeWidth = 8
              ..color = outlineColor,
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.bangers(
            color: color,
            fontWeight: fontWeight,
            fontSize: size,
            letterSpacing: 5,
          ),
        ),
      ],
    );
  }
}
