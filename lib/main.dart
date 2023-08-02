import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:santos_checker/constants/enum.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/controllers/side_menu_controller.dart';
import 'package:santos_checker/data/api/firebase_api.dart';
// import 'package:santos_checker/data/model/antrian_countup.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/data/provider/antrian_provider.dart';
import 'package:santos_checker/data/provider/gudang_provider.dart';
import 'package:santos_checker/data/provider/kategori_provider.dart';
import 'package:santos_checker/data/provider/report_provider.dart';
import 'package:santos_checker/pages/home/home_page.dart';
import 'package:santos_checker/pages/login/login_page.dart';
import 'package:santos_checker/pages/report/report_page.dart';
import 'package:santos_checker/pages/splash_screen/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  Get.put(SideMenuController());
  WidgetsFlutterBinding.ensureInitialized();
  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AntrianProvider("")),
                ChangeNotifierProvider(create: (_) => ReportProvider("")),
                ChangeNotifierProvider(create: (_) => GudangProvider()),
                ChangeNotifierProvider(create: (_) => KategoriProvider()),
              ],
              child: UpgradeAlert(
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: EasyLoading.init(),
                  title: 'Santos Checker',
                  theme: ThemeData(
                    unselectedWidgetColor: kGreyFormHintText,
                    disabledColor: kGreyFormIconNText,
                    scaffoldBackgroundColor: light,
                    buttonTheme: const ButtonThemeData(
                        buttonColor: kRed, focusColor: kRedBold),
                    textTheme: myTextTheme,
                    primarySwatch: Colors.red,

                    /// [pageTransitionsTheme] untuk mengatur tema/gaya transisi ketika akan ganti halaman
                    pageTransitionsTheme: const PageTransitionsTheme(builders: {
                      TargetPlatform.windows:
                          FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.android:
                          FadeUpwardsPageTransitionsBuilder()
                    }),
                  ),
                  home: const SplashScreenPage(),
                  navigatorObservers: [routeObserver],
                  onGenerateRoute: (RouteSettings settings) {
                    final args = settings.arguments;
                    switch (settings.name) {
                      case LoginPage.routeName:
                        return MaterialPageRoute(
                            builder: (_) => const LoginPage());
                      case HomePage.routeName:
                        return MaterialPageRoute(
                            builder: (_) => HomePage(
                                  currentUser: args as User,
                                  listWaktuAntrian: [],
                                ));
                      case ReportPage.routeName:
                        return MaterialPageRoute(
                            builder: (_) => ReportPage(
                                  currentUser: args as User,
                                ));
                      default:
                        return MaterialPageRoute(builder: (_) {
                          return const Scaffold(
                            body: Center(
                              child: Text('Page not found :('),
                            ),
                          );
                        });
                    }
                  },
                ),
              ));
        },
      ),
    );
  }
}
