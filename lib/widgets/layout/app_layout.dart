// import 'package:flutter/services.dart';
// import 'package:santos_checker/constants/controller.dart';
import 'package:santos_checker/data/model/antrian_countup.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/pages/home/home_page.dart';
// import 'package:santos_checker/pages/logout/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:santos_checker/pages/report/report_page.dart';

class AppLayout extends StatefulWidget {
  AppLayout(
      {Key? key,
      required this.currentUser,
      required this.currentLog,
      required this.selectedMenu})
      : super(key: key);
  int selectedMenu = 0;
  final User currentUser;
  final List<AntrianTimerCountUp> currentLog;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int currentMenu = 0;

  void onMenuTapped(int index) {
    setState(() {
      widget.selectedMenu = index;
      currentMenu = widget.selectedMenu;
    });
  }

  @override
  void initState() {
    onMenuTapped(widget.selectedMenu);
    super.initState();
  }

  // Future<bool> _onWillPop(int index) async {
  //   if (index == 0) {
  //     SystemNavigator.pop();
  //     // return false;
  //     return logoutDialog(
  //             context,
  //             "Close",
  //             "${widget.currentUser.name}, Apakah anda yakin ingin menutup aplikasi?",
  //             widget.currentUser) ??
  //         false;
  //   } else {
  //     sidemenuController.changeActiveItmeTo("Home");
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => AppLayout(
  //                   currentUser: widget.currentUser,
  //                   currentLog: widget.currentLog,
  //                   selectedMenu: 0,
  //                 )));
  //     return false;
  //   }
  // }

  Future<bool> _onWillPop() async {
    return true; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentMenu == 0
        ? HomePage(
            currentUser: widget.currentUser,
            listWaktuAntrian: widget.currentLog,
          )
        : currentMenu == 1
            ? ReportPage(
                currentUser: widget.currentUser,
              )
            : HomePage(
                currentUser: widget.currentUser,
                listWaktuAntrian: widget.currentLog,
              );
    return WillPopScope(
      // onWillPop: () => _onWillPop(currentMenu),
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: currentScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
