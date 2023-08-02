import 'package:flutter/material.dart';

class LoginScreenTopImage extends StatefulWidget {
  LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreenTopImage> createState() => _LoginScreenTopImageState();
}

class _LoginScreenTopImageState extends State<LoginScreenTopImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 15,
            top: MediaQuery.of(context).size.height / 1.5),
        child: Image.asset(
          'assets/images/Logo-Checker.png',
          width: MediaQuery.of(context).size.width / 8,
        ),
      ),
    );
  }
}
