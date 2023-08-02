import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:santos_checker/data/model/antrian_countup.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/pages/login/login_page.dart';
import 'package:santos_checker/widgets/layout/app_layout.dart';
import 'package:sizer/sizer.dart';
import 'package:sp_util/sp_util.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/';
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool isVisible = false;
  User userLoggedIn = User(
      idUser: '',
      username: '',
      password: '',
      name: '',
      token: '',
      email: '',
      loginStatus: 0,
      image: '',
      sja: '',
      kategori: '');
  List<AntrianTimerCountUp> logListWaktuAntrian = [];
  // String urlServer = "";

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      getPref();
    });

    super.initState();
  }

  getPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    if (SpUtil.getString('token')! != '') {
      setState(() {
        userLoggedIn = User(
            idUser: SpUtil.getString('id')!,
            username: SpUtil.getString('username')!,
            password: SpUtil.getString('password')!,
            name: SpUtil.getString('name')!,
            token: SpUtil.getString('token')!,
            email: SpUtil.getString('email')!,
            loginStatus: 1,
            image: SpUtil.getString('image')!,
            sja: SpUtil.getString('sja')!,
            kategori: SpUtil.getString('kategori')!);

        final parsed = SpUtil.getString('listWaktuAntrian')! == ""
            ? ""
            : jsonDecode(SpUtil.getString('listWaktuAntrian')!)
                .cast<Map<String, dynamic>>();
        logListWaktuAntrian = parsed == ""
            ? []
            : parsed
                .map<AntrianTimerCountUp>(
                    (json) => AntrianTimerCountUp.fromJson(json))
                .toList();
      });
      toHomePage(userLoggedIn, logListWaktuAntrian);
    } else {
      toLoginPage();
    }
  }

  toHomePage(User currentUser, List<AntrianTimerCountUp> logAntrian) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AppLayout(
              currentUser: currentUser,
              currentLog: logAntrian,
              selectedMenu: 0)));
    });
  }

  toLoginPage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 5, 0,
          MediaQuery.of(context).size.height / 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/Logo-Kapal-Api.png',
                height: MediaQuery.of(context).size.height / 4,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "PT. SANTOS JAYA ABADI",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: kTextWhiteColor,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0,
                    fontSize: 26.sp,
                    wordSpacing: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
