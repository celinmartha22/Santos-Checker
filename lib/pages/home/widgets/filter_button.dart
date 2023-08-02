import 'package:flutter/material.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:sizer/sizer.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.text,
    required this.press,
    required this.backColor,
    required this.borderColor,
    required this.textColor,
    required this.ikon,
    required this.fontSizeValue,
  }) : super(key: key);
  final String text;
  final Function() press;
  final Color backColor, textColor, borderColor;
  final double fontSizeValue;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 15,
      child: ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(
              BorderSide(width: 1.0, color: borderColor)),
          backgroundColor: MaterialStateProperty.all<Color>(backColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                ikon,
                color: kTextWhiteColor,
                size: kDefaultPadding,
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.sp,
                    letterSpacing: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
