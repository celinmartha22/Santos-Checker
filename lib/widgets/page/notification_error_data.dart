import 'package:flutter_svg/flutter_svg.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NotificationErrorData extends StatelessWidget {
  const NotificationErrorData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child:
                // Image.asset(
                //   'assets/images/Feeling sorry-bro.png',
                //   width: 250,
                //   filterQuality: FilterQuality.high,
                //   fit: BoxFit.contain,
                // ),
                SvgPicture.asset(
              'assets/images/Feeling sorry-bro.svg',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: light, fontSize: 16.sp),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Terjadi kesalahan yang tidak diketahui\n',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Silahkan cek data yang anda miliki',
                      style: TextStyle(color: kPrimaryColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
