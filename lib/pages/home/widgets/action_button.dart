import 'package:flutter/material.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/data/model/antrian.dart';
import 'package:sizer/sizer.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.text,
    required this.press,
    required this.antrian,
    required this.fontSizeValue,
  }) : super(key: key);
  final String text;
  final Function() press;
  final double fontSizeValue;
  final Antrian antrian;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height / 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 5, horizontal: kDefaultPadding / 5),
        child: TextButton(
          onPressed: press,
          style: TextButton.styleFrom(
              backgroundColor: text.toLowerCase() == "konfirmasi\nsupir"
                  ? kBlueLight
                  : text.toLowerCase() == "mulai\npersiapan"
                      ? kBrown
                      : text.toLowerCase() == "selesai\npersiapan"
                          ? kBrownLight
                          : text.toLowerCase() == "mulai\nbongkar"
                              ? kGreen
                              : text.toLowerCase() == "selesai\nbongkar"
                                  ? kRed
                                  : kGreyList,
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 50),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: BorderSide(
                  color: text.toLowerCase() == "konfirmasi\nsupir"
                      ? kBlueLight
                      : text.toLowerCase() == "mulai\npersiapan"
                          ? kBrown
                          : text.toLowerCase() == "selesai\npersiapan"
                              ? kBrownLight
                              : text.toLowerCase() == "mulai\nbongkar"
                                  ? kGreen
                                  : text.toLowerCase() == "selesai\nbongkar"
                                      ? kRed
                                      : kGreyBorder,
                  width: 1)),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: fontSizeValue.sp,
                  color: text.toLowerCase() == "selesai" ? kGreyBorder : kWhite,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0),
            ),
          ),
        ),
      ),
    );
  }
}
