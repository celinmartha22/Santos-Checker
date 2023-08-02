import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/pages/login/components/background_login.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late String urlServer = "";
  final TextEditingController urlServerController = TextEditingController();
  final TextEditingController urlAPIController = TextEditingController();
  String? _version;

  @override
  void initState() {
    super.initState();
    getAppVersion();
    getURLServer();
  }

  void getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    setState(() {
      _version = version;
    });
  }

  getURLServer() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundLogin(
      child: SingleChildScrollView(
        child: SafeArea(
          child: MobileLoginPage(
            version: _version ?? "",
            // logListWaktuAntrian: widget.currentLog,
          ),
          // child: Responsive(
          //   mobile: MobileLoginPage(
          //     version: _version ?? "",
          //     logListWaktuAntrian: widget.currentLog,
          //   ),

          //   // 'Pake yang MOBILE
          //   desktop: Row(
          //     children: [
          //       Expanded(
          //         child: LoginScreenTopImage(),
          //       ),
          //       Expanded(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Container(
          //               padding: const EdgeInsets.only(
          //                   left: kDefaultPadding / 3,
          //                   right: kDefaultPadding / 3,
          //                   top: kDefaultPadding / 3),
          //               decoration: const BoxDecoration(
          //                 color: kWhite,
          //                 borderRadius: BorderRadius.vertical(
          //                     top: Radius.circular(30),
          //                     bottom: Radius.circular(0)),
          //               ),
          //               width: 450,
          //               // child: LoginForm(),
          //               child: Container(),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}

class MobileLoginPage extends StatelessWidget {
  MobileLoginPage({
    Key? key,
    required this.version,
    // required this.logListWaktuAntrian,
  }) : super(key: key);
  String version;
  // List<AntrianTimerCountUp> logListWaktuAntrian;

  @override
  Widget build(BuildContext context) {
    return LandscapeView(
      version: version,
      // logListWaktuAntrian: logListWaktuAntrian,
    );
    // Orientation orientation = MediaQuery.of(context).orientation;
    // if (orientation == Orientation.portrait) {
    //   // return PotraitView();
    // } else {
    //   return LandscapeView(
    //     version: version,
    //     logListWaktuAntrian: logListWaktuAntrian,
    //   );
    // }
  }
}

// class PotraitView extends StatelessWidget {
//   const PotraitView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         LoginScreenTopImage(),
//         Row(
//           children: [
//             const Spacer(),
//             Expanded(
//               flex: 8,
//               child: LoginForm(
//                 logListWaktuAntrian: [],
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ],
//     );
//   }
// }

class LandscapeView extends StatelessWidget {
  LandscapeView({
    super.key,
    required this.version,
    // required this.logListWaktuAntrian,
  });
  String version;
  // List<AntrianTimerCountUp> logListWaktuAntrian;
  // final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LoginScreenTopImage(),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: kDefaultPadding / 3, right: kDefaultPadding / 3, top: 0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.circular(20)),
          ),
          width: MediaQuery.of(context).size.width / 2.3,
          height: MediaQuery.of(context).size.height / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //   flex: 1,
              //   child: InkWell(
              //     onTap: () => settingDialog(context, _urlController),
              //     child: Image.asset(
              //       "assets/images/Logo-Santos.png",
              //       width: MediaQuery.of(context).size.height,
              //       alignment: Alignment.centerRight,
              //       // width: 120,
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 1.5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Welcome",
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kRed,
                                    fontSize: 15.sp,
                                    letterSpacing: 0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:                       
                        Image.asset(
                            "assets/images/Logo-Santos.png",
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            // width: 120,
                          ),
                        // InkWell(
                        //   onTap: () => settingDialog(context),
                        //   child: Image.asset(
                        //     "assets/images/Logo-Santos.png",
                        //     width: MediaQuery.of(context).size.width,
                        //     alignment: Alignment.centerRight,
                        //     // width: 120,
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 1.5),
                  child: Text(
                    "Silahkan masukkan NIK dan\nPassword untuk Login",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kGreyFormIconNText,
                        fontSize: 10.sp,
                        letterSpacing: 0),
                  ),
                ),
              ),
              const Expanded(
                  flex: 6,
                  child: LoginForm(
                      // logListWaktuAntrian: logListWaktuAntrian,
                      )),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: Text(
                    "Version $version",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kGreyFormHintText,
                        letterSpacing: 0,
                        fontSize: 9.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        )
      ],
    );
  }
}
