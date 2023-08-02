import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

const light = Color(0xFFF7F8FC);
const lightGrey = Color(0xFFA4A6B3);
const dark = Color(0xFF363740);
const active = Color(0xFF3C19C0);

const double defaultPadding = 16.0;

//colors
const Color kPrimaryColor = Color(0xFF870100);
const Color kPrimaryLightColor = Color.fromARGB(255, 189, 27, 27);
const Color kSecondaryColor = Color.fromARGB(255, 228, 52, 52);
const Color kSecondaryLightColor = Color.fromARGB(255, 253, 102, 102);
const Color kAdditionalColor = Color(0xFFFDCA30);
const Color kAdditionalLightColor = Color.fromARGB(255, 255, 223, 127);
const Color kBackgroundColor = Color.fromARGB(255, 252, 188, 188);
const Color kBackgroundLightColor = Color.fromARGB(255, 252, 215, 215);
const Color kBackgroundVeryLightColor = Color.fromARGB(255, 253, 247, 228);
const Color kTextBlackColor = Color(0xFF313131);
const Color kTextWhiteColor = Color(0xFFFFFFFF);
const Color kTextDarkColor = Color(0xFF33354c);
const Color kTextLightColor = Color(0xFFa6abc8);
const Color kSubTextColor = Color(0xFF757996);
const Color kContainerColor = Color(0xFF777777);
const Color kOtherColor = Color(0xFFF4F6F7);
const Color kErrorBorderColor = Color(0xFFE74C3C);

const Color kGreen = Color(0xFF00AB36);
const Color kRed = Color(0xFFDF0024);
const Color kRedBold = Color(0xFFB2011D);
const Color kBrown = Color(0xFF803A09);
const Color kBrownLight = Color(0xFFc4994a);
const Color kOrange = Color(0xFFFFB321);
const Color kOrangeBorder = Color(0xFFD28B00);
const Color kBlueLight = Color(0xFF63a3ea);
const Color kBlue = Color(0xFF325a95);
const Color kWhite = Color(0xFFFFFFFF);
const Color kWhiteBound = Color(0xFFF3F6F8);
const Color kBlack = Color(0xFF202020);
const Color kGrey = Color(0xFFEEEEEE);
const Color kGreyList = Color(0xFFF4F4F4);
const Color kGreyBorder = Color(0xFFD7D7D7);
const Color kGreyBlockText = Color.fromARGB(255, 160, 160, 160);
const Color kGreyForm = Color(0xFFF5F4EC);
const Color kGreyFormIconNText = Color(0xFF45483C);
const Color kGreyFormHintText = Color(0xFF76786B);


final TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.quintessential(
      fontSize: 30.sp,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: Colors.white),
  displayMedium: GoogleFonts.quintessential(
      fontSize: 20.sp,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: Colors.white),
  displaySmall: GoogleFonts.quintessential(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white),
  headlineLarge: GoogleFonts.vollkorn(fontSize: 30.sp),
  headlineMedium: GoogleFonts.vollkorn(fontSize: 28.sp),
  headlineSmall: GoogleFonts.vollkorn(fontSize: 26.sp),
  titleLarge: GoogleFonts.roboto(fontSize: 30.sp),
  titleMedium: GoogleFonts.roboto(fontSize: 24.sp),
  titleSmall: GoogleFonts.roboto(fontSize: 22.sp),
  labelLarge: GoogleFonts.roboto(fontSize: 20.sp),
  labelMedium: GoogleFonts.roboto(fontSize: 18.sp),
  labelSmall: GoogleFonts.roboto(fontSize: 16.sp),
  bodyLarge: GoogleFonts.roboto(fontSize: 14.sp),
  bodyMedium: GoogleFonts.roboto(fontSize: 12.sp),
  bodySmall: GoogleFonts.roboto(fontSize: 10.sp),
);

//default value
const kDefaultPadding = 20.0;

const sizedBox = SizedBox(
  height: kDefaultPadding,
);
const kWidthSizedBox = SizedBox(
  width: kDefaultPadding,
);

const kHalfSizedBox = SizedBox(
  height: kDefaultPadding / 2,
);

const kHalfWidthSizedBox = SizedBox(
  width: kDefaultPadding / 2,
);

final kTopBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 20),
  topRight:
      Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 20),
);

final kBottomBorderRadius = BorderRadius.only(
  bottomRight:
      Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 40),
  bottomLeft:
      Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 40),
);

final kInputTextStyle = GoogleFonts.poppins(
    color: kTextBlackColor, fontSize: 11.sp, fontWeight: FontWeight.w500);

//validation for mobile
const String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

//validation for email
const String emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
