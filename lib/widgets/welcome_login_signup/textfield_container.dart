import 'package:flutter/material.dart';
import 'package:santos_checker/constants/style.dart';

class TextfieldContainer extends StatelessWidget {
  const TextfieldContainer(
      {super.key,
      required this.child,
      required this.backColor,
      required this.shadowColor,
      required this.offset,
      required this.widthDivide});
  final Widget child;
  final Color backColor;
  final Color shadowColor;
  final Offset offset;
  final double widthDivide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding / 4),
      padding: const EdgeInsets.only(left: kDefaultPadding / 2),
      width: MediaQuery.of(context).size.width / widthDivide,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: offset, // Shadow position
          ),
        ],
      ),
      child: child,
    );
  }
}
