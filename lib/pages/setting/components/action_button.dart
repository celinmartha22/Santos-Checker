// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class ActionButton extends StatelessWidget {
//   const ActionButton({
//     Key? key,
//     required this.text,
//     required this.press,
//     required this.backColor,
//     required this.textColor,
//   }) : super(key: key);
//   final String text;
//   final Function() press;
//   final Color backColor, textColor;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height/15,
//       child: ElevatedButton(
//         onPressed: press,
//         style: ButtonStyle(
//           elevation: MaterialStateProperty.all(0),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//           ),
//           backgroundColor: MaterialStateProperty.all<Color>(backColor),
//         ),
//         child: Text(
//           text.toUpperCase(),
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodySmall!.copyWith(
//               color: textColor, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 0),
//         ),
//       ),
//     );
//   }
// }
