// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:dart_ping/dart_ping.dart';
// import 'package:santos_checker/constants/style.dart';
// import 'package:santos_checker/data/helpers/login_action.dart';
// import 'package:santos_checker/pages/setting/components/action_button.dart';
// import 'package:santos_checker/widgets/welcome_login_signup/rounded_input_textfield.dart';
// import 'package:sizer/sizer.dart';
// import 'package:sp_util/sp_util.dart';

// class BoxDialog extends StatefulWidget {
//   const BoxDialog({super.key});

//   @override
//   State<BoxDialog> createState() => _BoxDialogState();
// }

// class _BoxDialogState extends State<BoxDialog> {
//   final TextEditingController urlServerController = TextEditingController();
//   final TextEditingController urlAPIController = TextEditingController();
//   // bool? _isServerConnect;

//   getURLServer() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await SpUtil.getInstance();
//     setState(() {
//       urlServerController.text = SpUtil.getString('urlServer')!;
//       urlAPIController.text = SpUtil.getString('urlAPI')!;
//     });
//   }

//   Future<void> _pingConnection() async {
//     bool? isPingable;
//     try {
//       if (urlServerController.text.toString() != "") {
//         EasyLoading.show();
//         var pings = Ping(urlServerController.text, count: 1);
//         pings.stream.listen((event) {
//           setState(() {
//             if (event.summary != null) {
//               isPingable = event.summary!.received == 1 ? true : false;
//               if (isPingable!) {
//                 EasyLoading.showSuccess('Connect Success!');
//               } else {
//                 EasyLoading.showError('Failed to connect');
//               }
//             } else {
//               EasyLoading.showError(
//                   'Failed to connect\nPlease check the name and try again');
//             }
//           });
//         });
//       } else {
//         setState(() {
//           isPingable = false;
//           EasyLoading.showError('Failed to connect');
//         });
//       }
//     } on SocketException {
//       setState(() {
//         isPingable = false;
//         EasyLoading.showError('Failed to connect');
//       });
//     }
//   }

//   void testAuthentication() {
//     EasyLoading.show();
//     if (urlAPIController.text.toString() != "") {
//       LoginAction()
//           .testAuth(urlAPIController.text.toString(), "", "")
//           .then((value) {
//         if (value.statusCode == 404) {
//           if (value.body.toString().toLowerCase().contains("success")) {
//             EasyLoading.showSuccess('Connect Success!');
//           } else {
//             EasyLoading.showError('Failed to connect');
//           }
//         } else {
//           EasyLoading.showError('Failed to connect');
//         }
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.showError('Failed to connect');
//     }
//   }

//   void saveSetting(BuildContext context, String urlServer, String urlAPI) {
//     if (urlServer.isEmpty || urlAPI.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content:
//             Text("Gagal Simpan, URL Server dan URL API tidak boleh kosong"),
//         backgroundColor: Colors.red,
//       ));
//     } else {
//       if (urlServer != "" && urlAPI != "") {
//         SpUtil.putString('urlServer', urlServer);
//         SpUtil.putString('urlAPI', urlAPI);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Berhasil menyimpan data pengaturan"),
//           backgroundColor: Colors.green,
//         ));
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content:
//               Text("Gagal Simpan, URL Server dan URL API tidak boleh kosong"),
//           backgroundColor: Colors.red,
//         ));
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getURLServer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height / 1.5,
//         width: MediaQuery.of(context).size.width / 1.5,
//         child: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Server Setting',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(
//                                     color: kBlack,
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.bold)),
//                         Image.asset(
//                           'assets/images/Logo-Santos-polos.png',
//                           width: 60,
//                           filterQuality: FilterQuality.high,
//                           fit: BoxFit.contain,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "URL Server",
//                           textAlign: TextAlign.left,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: kGreyFormIconNText,
//                                   fontSize: 8.sp,
//                                   letterSpacing: 0),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             RoundedInputTextfield(
//                               widthDivide: 2.2,
//                               change: (value) {},
//                               icon: Icons.settings,
//                               hintText: "Isikan URL server",
//                               controller: urlServerController,
//                               obscureTextValue: false,
//                               suffixIconVisibility: false,
//                               action: TextInputAction.next,
//                               backColor: kGrey,
//                               shadowColor: kGrey,
//                               offset: const Offset(0, 0),
//                               cursorColor: kGreyFormIconNText,
//                               iconColor: kGreyFormIconNText,
//                               textColor: kGreyFormIconNText,
//                               hinttextColor: kGreyFormHintText,
//                               myValidationNote: "Masukkan URL server.",
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width / 80,
//                             ),
//                             ActionButton(
//                                 text: "Test",
//                                 press: () {
//                                   _pingConnection();
//                                 },
//                                 backColor: kRed,
//                                 textColor: kWhite),
//                           ],
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height / 60,
//                         ),
//                         Text(
//                           "URL API",
//                           textAlign: TextAlign.left,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: kGreyFormIconNText,
//                                   fontSize: 8.sp,
//                                   letterSpacing: 0),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             RoundedInputTextfield(
//                               widthDivide: 2.2,
//                               change: (value) {},
//                               icon: Icons.settings,
//                               hintText: "Isikan URL API",
//                               controller: urlAPIController,
//                               obscureTextValue: false,
//                               suffixIconVisibility: false,
//                               action: TextInputAction.done,
//                               backColor: kGrey,
//                               shadowColor: kGrey,
//                               offset: const Offset(0, 0),
//                               cursorColor: kGreyFormIconNText,
//                               iconColor: kGreyFormIconNText,
//                               textColor: kGreyFormIconNText,
//                               hinttextColor: kGreyFormHintText,
//                               myValidationNote: "Masukkan URL API.",
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width / 80,
//                             ),
//                             ActionButton(
//                                 text: "Test",
//                                 press: () {
//                                   testAuthentication();
//                                 },
//                                 backColor: kRed,
//                                 textColor: kWhite),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: kRedBold, borderRadius: BorderRadius.circular(20)),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ActionButton(
//                         text: "KEMBALI",
//                         press: () {
//                           Navigator.of(context).pop();
//                         },
//                         backColor: kWhite,
//                         textColor: kBlack),
//                     ActionButton(
//                         text: "SIMPAN",
//                         press: () {
//                           saveSetting(context, urlServerController.text,
//                               urlAPIController.text);
//                         },
//                         backColor: kGreen,
//                         textColor: kWhite)
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
