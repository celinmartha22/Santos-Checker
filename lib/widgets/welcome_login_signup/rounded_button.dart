import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.backColor,
    required this.textColor,
    required this.textSize,
    required this.heightDivide,
    required this.radius,
  }) : super(key: key);
  final String text;
  final Function() press;
  final Color backColor, textColor;
  final double textSize;
  final double heightDivide;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3.5,
      height: MediaQuery.of(context).size.height / heightDivide,
      child: ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(backColor),
        ),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: textSize.sp,
              letterSpacing: 0),
        ),
      ),
    );
  }
}
