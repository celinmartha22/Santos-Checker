import 'package:santos_checker/widgets/welcome_login_signup/textfield_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedInputTextfield extends StatefulWidget {
  RoundedInputTextfield(
      {super.key,
      required this.widthDivide,
      required this.hintText,
      this.icon = Icons.person,
      required this.controller,
      required this.action,
      required this.cursorColor,
      required this.obscureTextValue,
      required this.iconColor,
      required this.textColor,
      required this.hinttextColor,
      required this.change,
      required this.backColor,
      required this.shadowColor,
      required this.offset,
      required this.myValidationNote,
      required this.suffixIconVisibility});
  final double widthDivide;
  final String hintText;
  final IconData icon;
  final TextInputAction action;
  final TextEditingController controller;
  final Color backColor;
  final Color shadowColor;
  final Color cursorColor;
  final Color iconColor;
  final Color textColor;
  final Color hinttextColor;
  final Offset offset;
  late bool obscureTextValue;
  final bool suffixIconVisibility;
  final String myValidationNote;
  final Function(String) change;

  @override
  State<RoundedInputTextfield> createState() => _RoundedInputTextfieldState();
}

class _RoundedInputTextfieldState extends State<RoundedInputTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextfieldContainer(
        widthDivide: widget.widthDivide,
        backColor: widget.backColor,
        shadowColor: widget.shadowColor,
        offset: widget.offset,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.myValidationNote != ""
                  ? widget.myValidationNote
                  : null;
            } else {
              return null;
            }
          },
          onChanged: widget.change,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: widget.textColor, letterSpacing: 0, fontSize: 10.sp),
          controller: widget.controller,
          obscureText: widget.obscureTextValue,
          textInputAction: widget.action,
          cursorColor: widget.cursorColor,
          onSaved: (email) {},
          decoration: InputDecoration(
              suffixIcon: widget.suffixIconVisibility
                  ? IconButton(
                      iconSize: MediaQuery.of(context).size.width / 50,
                      alignment: Alignment.center,
                      onPressed: () {
                        setState(() {
                          widget.obscureTextValue = !widget.obscureTextValue;
                        });
                      },
                      icon:
                          widget.obscureTextValue && widget.suffixIconVisibility
                              ? Icon(
                                  Icons.visibility,
                                  color: widget.hinttextColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: widget.hinttextColor,
                                ))
                  : null,
              icon: Icon(
                widget.icon,
                color: widget.iconColor,
                size: MediaQuery.of(context).size.width / 40,
              ),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: widget.hinttextColor,
                  letterSpacing: 0,
                  fontSize: 10.sp),
              border: InputBorder.none),
        ));
  }
}
