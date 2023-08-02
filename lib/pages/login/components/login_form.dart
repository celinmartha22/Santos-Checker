import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:santos_checker/constants/controller.dart';
import 'package:santos_checker/data/helpers/login_action.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';
import 'package:santos_checker/data/model/antrian_countup.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/responsive.dart';
import 'package:santos_checker/routing/routes.dart';
import 'package:santos_checker/widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:sizer/sizer.dart';
import 'package:sp_util/sp_util.dart';

import '../../../widgets/welcome_login_signup/rounded_button.dart';
import '../../../widgets/welcome_login_signup/rounded_input_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController urlServerController = TextEditingController();
  final TextEditingController urlAPIController = TextEditingController();
  Duration get loginTime => const Duration(milliseconds: 2250);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> authentication() async {
      String nik = _nikController.text;
      String password = _passwordController.text;

      if (nik.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal Simpan, NIK dan Password tidak boleh kosong"),
          backgroundColor: Colors.red,
        ));
      } else {
        EasyLoading.show();
        LoginAction().auth(nik, password).then((value) {
          if (value.statusCode == 200 || value.statusCode == 404) {
            if (value.body.toString().toLowerCase().contains("success")) {
              if (value.body['success'].toString() == "true") {
                var responseBody = value.body;
                final userLogin = User(
                    idUser: "",
                    username: "",
                    password: password,
                    name: responseBody['data']['nama'],
                    email: "",
                    image: "",
                    loginStatus: 1,
                    token: responseBody['data']['token'],
                    sja: responseBody['data']['sja'],
                    kategori: responseBody['data']['kategori']);

                SpUtil.putString('name', userLogin.name);
                SpUtil.putString('sja', userLogin.sja);
                SpUtil.putString('token', userLogin.token);
                SpUtil.putString('kategori', userLogin.kategori);

                final parsed = SpUtil.getString('listWaktuAntrian')! == ""
                    ? ""
                    : jsonDecode(SpUtil.getString('listWaktuAntrian')!)
                        .cast<Map<String, dynamic>>();
                final List<AntrianTimerCountUp> logListWaktuAntrian =
                    parsed == ""
                        ? []
                        : parsed
                            .map<AntrianTimerCountUp>(
                                (json) => AntrianTimerCountUp.fromJson(json))
                            .toList();

                if (!sidemenuController.isActive(sideMenuItems[0][0])) {
                  sidemenuController.changeActiveItmeTo(sideMenuItems[0][0]);
                  if (Responsive.isMobile(context)) {
                    Get.back();
                  }
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppLayout(
                              currentUser: userLogin,
                              currentLog: logListWaktuAntrian,
                              selectedMenu: 0,
                            )));

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(responseBody['message'].toString()),
                  backgroundColor: Colors.green,
                ));
              } else {
                if (value.body.toString().toLowerCase().contains("message")) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Gagal Login, ${value.body['message'].toString()}"),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Gagal Login, Silahkan cek koneksi internet anda"),
                    backgroundColor: Colors.red,
                  ));
                }
              }
            } else {
              if (value.body.toString().toLowerCase().contains("message")) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Gagal Login, ${value.body['message'].toString()}"),
                  backgroundColor: Colors.red,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text("Gagal Login, Silahkan cek koneksi internet anda"),
                  backgroundColor: Colors.red,
                ));
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Gagal Login, Silahkan cek koneksi internet anda"),
              backgroundColor: Colors.red,
            ));
          }
          EasyLoading.dismiss();
        });
      }
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
            ),
            Text(
              "NIK",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kGreyFormIconNText,
                  fontSize: 10.sp,
                  letterSpacing: 0),
            ),
            RoundedInputTextfield(
              widthDivide: 3.5,
              change: (value) {},
              icon: Icons.person,
              hintText: "Isikan NIK",
              controller: _nikController,
              obscureTextValue: false,
              suffixIconVisibility: false,
              action: TextInputAction.next,
              backColor: kGreyForm,
              shadowColor: kGreyForm,
              offset: const Offset(0, 0),
              cursorColor: kGreyFormIconNText,
              iconColor: kGreyFormIconNText,
              textColor: kGreyFormIconNText,
              hinttextColor: kGreyFormHintText,
              myValidationNote: "Masukkan NIK anda.",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
            ),
            Text(
              "Password",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kGreyFormIconNText,
                  fontSize: 10.sp,
                  letterSpacing: 0),
            ),
            RoundedInputTextfield(
              widthDivide: 3.5,
              change: (value) {},
              icon: Icons.verified_user_outlined,
              hintText: "Isikan Password",
              controller: _passwordController,
              obscureTextValue: true,
              suffixIconVisibility: true,
              action: TextInputAction.done,
              backColor: kGreyForm,
              shadowColor: kGreyForm,
              offset: const Offset(0, 0),
              cursorColor: kGreyFormIconNText,
              iconColor: kGreyFormIconNText,
              textColor: kGreyFormIconNText,
              hinttextColor: kGreyFormHintText,
              myValidationNote: "Masukkan password anda.",
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 40,
            // ),
            // Text(
            //   "SJA",
            //   textAlign: TextAlign.left,
            //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //       fontWeight: FontWeight.bold,
            //       color: kGreyFormIconNText,
            //       letterSpacing: 0),
            // ),
            // RoundedInputTextfield(
            //   change: (value) {},
            //   icon: Icons.verified_user_outlined,
            //   hintText: "Isikan SJA",
            //   controller: _passwordController,
            //   obscureTextValue: true,
            //   suffixIconVisibility: true,
            //   action: TextInputAction.done,
            //   backColor: kGreyForm,
            //   shadowColor: kGreyForm,
            //   offset: const Offset(0, 0),
            //   cursorColor: kGreyFormIconNText,
            //   iconColor: kGreyFormIconNText,
            //   textColor: kGreyFormIconNText,
            //   hinttextColor: kGreyFormHintText,
            //   myValidationNote: "Masukkan sja anda.",
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Hero(
              tag: "login_btn",
              child: RoundedButton(
                  text: "login",
                  textSize: 10,
                  heightDivide: 13,
                  radius: 20,
                  press: () {
                    authentication();
                  },
                  backColor: kRed,
                  textColor: kWhite),
            ),
          ],
        ),
      ),
    );
  }
}
