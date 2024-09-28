import 'package:flutter/material.dart';

class RefractedTextWidget extends StatelessWidget {
  const RefractedTextWidget({
    Key? key,
    required this.text,
    this.textSize,
    this.textColor,
    this.textWeight,
    this.onTap,
    this.maxLines,
    this.align,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.height=1,
    this.fontFamily
  }) : super(key: key);

  final String text;
  final double? textSize;
  final Color? textColor;
  final FontWeight? textWeight;
  final VoidCallback? onTap;
  final int? maxLines;
  final TextAlign? align;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double height;
  final String? fontFamily;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: align ?? TextAlign.start,
        overflow: overflow,
        style: TextStyle(
          fontFamily: fontFamily,
          height: height,
            decoration: decoration,
            decorationColor:Colors.grey,
            
            color: textColor ?? Colors.black,
            fontSize: textSize ?? 16,
            fontWeight: textWeight),
      ),
    );
  }
}
