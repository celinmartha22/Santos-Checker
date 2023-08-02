import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:santos_checker/constants/controller.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/data/helpers/logout_action.dart';
import 'package:santos_checker/data/model/antrian.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/pages/home/home_page.dart';
import 'package:santos_checker/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:sp_util/sp_util.dart';

logoutDialog(
    BuildContext context, String tipe, String contentText, User userLoggedin) {
  debugPrint("LOGOUT User => ${userLoggedin.token} - ${userLoggedin.name}");
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // contentPadding: EdgeInsets.zero,
          title: Text(
            tipe,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp),
            // textAlign: TextAlign.center,
          ),
          content: Text(
            contentText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.normal,
                fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "Batal",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "Ya",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                if (tipe.toLowerCase() == "logout") {
                  logout(context, userLoggedin.token);
                } else if (tipe.toLowerCase() == "close") {
                  SystemNavigator.pop();
                }
              },
            ),
          ],
        );
      });
}

void logout(BuildContext context, String token) {
  if (token.isEmpty) {
    Get.snackbar("Error", "Token login kosong",
        backgroundColor: Colors.red, colorText: Colors.white);
  } else {
    EasyLoading.show();
    LogoutAction().logout(token).then((value) {
      if (value.statusCode != null) {
        if (value.statusCode == 200) {
          var responseBody = value.body;
          if (responseBody['success'].toString().toLowerCase() == "true") {
            final userLogin = User(
                idUser: "",
                username: "",
                password: "",
                name: "",
                email: "",
                image: "",
                loginStatus: 0,
                token: "",
                sja: "",
                kategori: "");

            SpUtil.putString('name', userLogin.name);
            SpUtil.putString('sja', userLogin.sja);
            SpUtil.putString('token', userLogin.token);
            SpUtil.putString('kategori', userLogin.kategori);
            sidemenuController.changeActiveItmeTo("Home");
            HomePage.listAntrianNotifier.value =
                ListAntrian(antrians: [], statistik: []);
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          } else {
            Navigator.pop(context);
          }
        } else {
          Get.snackbar("Error", value.body['message'],
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        EasyLoading.showError("Logout Failed");
      }
      EasyLoading.dismiss();
    });
  }
}
