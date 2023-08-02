import 'package:flutter_svg/flutter_svg.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NotificationNoData extends StatelessWidget {
  const NotificationNoData({
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
                //   'assets/images/Empty-bro.png',
                //   width: 250,
                //   filterQuality: FilterQuality.high,
                //   fit: BoxFit.contain,
                // ),
                SvgPicture.asset(
              'assets/images/Empty-bro.svg',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Text('Data kosong\nTidak ada data yang ditampilkan',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: kPrimaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ));
  }
}
