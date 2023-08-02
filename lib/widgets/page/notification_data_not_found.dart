import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationDataNotFound extends StatelessWidget {
  const NotificationDataNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 10),
            child: Center(
                child:
                    // Image.asset(
                    //   'assets/images/Empty-amico.png',
                    //   // 'assets/images/Oops 404 Error with a broken robot-cuate.png',
                    //   // 'assets/images/404 Error with a cute animal-pana.png',
                    //   width: 250,
                    //   filterQuality: FilterQuality.high,
                    //   fit: BoxFit.contain,
                    // ),
                    SvgPicture.asset(
              'assets/images/Empty-amico.svg',
              width: 250,
              fit: BoxFit.contain,
            ))));
  }
}
