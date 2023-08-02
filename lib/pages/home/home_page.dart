import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/controllers/network_connectivity_controller.dart';
import 'package:santos_checker/data/helpers/bongkar_action.dart';
import 'package:santos_checker/data/helpers/device_connection_helper.dart';
import 'package:santos_checker/data/helpers/konfirmasi_action.dart';
import 'package:santos_checker/data/helpers/persiapan_action.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';
import 'package:santos_checker/data/model/antrian.dart';
import 'package:santos_checker/data/model/antrian_countup.dart';
import 'package:santos_checker/data/model/gudang.dart';
import 'package:santos_checker/data/model/kategori.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/data/provider/antrian_provider.dart';
import 'package:santos_checker/data/provider/gudang_provider.dart';
import 'package:santos_checker/data/provider/kategori_provider.dart';
import 'package:santos_checker/pages/home/widgets/action_button.dart';
import 'package:santos_checker/pages/home/widgets/filter_button.dart';
import 'package:santos_checker/pages/logout/logout_dialog.dart';
// import 'package:santos_checker/pages/setting/setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:santos_checker/widgets/layout/app_layout.dart';
import 'package:santos_checker/widgets/welcome_login_signup/rounded_button.dart';
import 'package:sizer/sizer.dart';
import 'package:sp_util/sp_util.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  static String messageAntrianNotifier = "";
  static final ValueNotifier<ListAntrian> listAntrianNotifier =
      ValueNotifier(ListAntrian(antrians: [], statistik: []));
  static final ValueNotifier<ListGudang> listGudangNotifier =
      ValueNotifier(ListGudang(gudangs: []));
  static final ValueNotifier<ListKategori> listKategoriNotifier =
      ValueNotifier(ListKategori(kategoris: []));

  HomePage(
      {Key? key, required this.currentUser, required this.listWaktuAntrian})
      : super(key: key);
  final User currentUser;
  List<AntrianTimerCountUp> listWaktuAntrian;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool timerStarted = false;
  String version = "";
  late bool isConnectInternet = true;
  late bool isConnectServer = true;
  final Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _deviceConnectivity = NetworkConnectivity.instance;
  late List<Antrian> listAsisten;
  final ScrollController scrollController = ScrollController();
  // late Gudang selectedGudang = Gudang(idGudang: "", namaGudang: "");
  // late Kategori selectedKategori = Kategori(idKategori: "", namaKategori: "");
  late Timer _timerClock;
  // late Timer _timerGetData = Timer(const Duration(seconds: 7), () {});
  var _timeNow = DateFormat('Hms').format(DateTime.now());
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    checkDeviceConnection(context, _deviceConnectivity, _source);
    // _pingConnection();
    startTimer();
    // selectedGudang = Gudang(idGudang: "3", namaGudang: "3");
    _getDataListAntrian();
    // setUpTimedFetchDatabyGudang(); //selectedGudang.namaGudang
    initPushNotifications();
    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Firebase Messaging Background Handler ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Payload: ${message.data}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text("${message.notification?.title}, ${message.notification?.body}"),
      backgroundColor: Colors.green,
    ));
    _getDataListAntrian();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      debugPrint("ForegroundNotification: ${notification.body}");
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${notification.title}, ${notification.body}"),
        backgroundColor: Colors.green,
      ));
      _getDataListAntrian();
      debugPrint("_getDataListAntrian FirebaseMessaging.onMessage.listen");
    });
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    debugPrint('Handle Message ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Payload: ${message.data}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text("${message.notification?.title}, ${message.notification?.body}"),
      backgroundColor: Colors.green,
    ));
    _getDataListAntrian();
  }

  // void showFlutterNotification(RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification == null) return;
  //   debugPrint("ForegroundNotification: ${notification.body}");
  //   _localNotifications.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               _androidChannel.id, _androidChannel.name,
  //               channelDescription: _androidChannel.description,
  //               icon: '@drawable/ic_launcher')),
  //       payload: jsonEncode(message.toMap()));
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text("${notification.title}, ${notification.body}"),
  //     backgroundColor: Colors.green,
  //   ));
  // }

  @override
  void dispose() {
    _timerClock.cancel();
    // _timerGetData.cancel();
    _deviceConnectivity.disposeStream();
    super.dispose();
  }

  // void checkDeviceConnection() {
  //   _deviceConnectivity.initialise();
  //   _deviceConnectivity.myStream.listen((source) {
  //     _source = source;
  //     late bool isConnectTemp = true;
  //     switch (_source.keys.toList()[0]) {
  //       case ConnectivityResult.mobile:
  //         isConnectTemp = _source.values.toList()[0] ? true : false;
  //         break;
  //       case ConnectivityResult.wifi:
  //         isConnectTemp = _source.values.toList()[0] ? true : false;
  //         break;
  //       case ConnectivityResult.none:
  //       default:
  //         isConnectTemp = false;
  //     }

  //     if (isConnectTemp != isConnectInternet) {
  //       isConnectInternet = isConnectTemp;
  //       if (isConnectInternet) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Anda kembali Online"),
  //           backgroundColor: Colors.green,
  //         ));
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Anda sedang Offline. Periksa koneksi internet anda"),
  //           backgroundColor: Colors.grey,
  //         ));
  //       }
  //     }
  //   });
  // }

  Future<bool> pingConnection(
      String buttonText, Antrian dataAntrian, User user) async {
    bool isPingable = false;
    String replaceTextButton =
        buttonText.replaceAll(RegExp(r"\s+\b|\b\s"), "\n");
    try {
      String urlServer = await getURLServer();
      if (urlServer.toString() != "") {
        var pings = Ping(urlServer, count: 1);
        pings.stream.listen((event) {
          setState(() {
            if (event.summary != null) {
              isPingable = event.summary!.received == 1 ? true : false;
              if (isPingable) {
                goAction(replaceTextButton, dataAntrian);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Gagal tes koneksi ke server"),
                  backgroundColor: Colors.red,
                ));
              }
              if (isPingable != isConnectServer) {
                isConnectServer = isPingable;
                if (isConnectServer) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Server kembali Online"),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Server sedang Offline. Santos Checker tidak terkoneksi ke server pusat"),
                    backgroundColor: Colors.red,
                  ));
                }
              }
            }
          });
        });
      } else {
        setState(() {
          isPingable = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "URL Server kosong. Silahkan ubah pengaturan server terlebih dahulu"),
            backgroundColor: Colors.red,
          ));
        });
      }
    } on SocketException {
      setState(() {
        isPingable = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal tes koneksi ke server"),
          backgroundColor: Colors.red,
        ));
      });
    }
    return isPingable;
  }

  void startTimer() {
    _timerClock = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
        });
        // if (DateTime.now().second == 0) {
        //   //&& _timerGetData.isActive
        //   _timerGetData.cancel();
        //   setUpTimedFetchDatabyGudang();
        // }
      },
    );
  }

  void stopGetData() {
    _timerClock = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
        });
      },
    );
  }

  // setUpTimedFetchDatabyGudang() {
  //   //namaGudang
  //   _timerGetData = Timer.periodic(
  //     const Duration(seconds: 7),
  //     (timer) {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  //       _getDataListAntrian();
  //     },
  //   );
  // }

  // Future<String> getURLServer() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await SpUtil.getInstance();
  //   String urlServer = SpUtil.getString('urlServer')!;
  //   return urlServer;
  // }

  // Future _getDataListAntrian(var namaGudang) async {
  //   final listAntrianData =
  //       await Provider.of<AntrianProvider>(context, listen: false)
  //           .getAntrianAll(widget.currentUser.token, namaGudang);
  //   setState(() {
  //     HomePage.listAntrianNotifier.value = listAntrianData;
  //   });
  // }

  Future _getDataListAntrian() async {
    //var namaGudang
    debugPrint("_getDataListAntrian RUN");
    final listAntrianData =
        await Provider.of<AntrianProvider>(context, listen: false)
            .getAntrianAll(widget.currentUser.token); //namaGudang
    if (listAntrianData is String) {
      setState(() {
        HomePage.messageAntrianNotifier = listAntrianData;
        HomePage.listAntrianNotifier.value =
            ListAntrian(antrians: [], statistik: []);
      });
    } else {
      setState(() {
        HomePage.messageAntrianNotifier = "";
        HomePage.listAntrianNotifier.value = listAntrianData;
      });
    }
  }

  Future _getGudang() async {
    final listGudang = await Provider.of<GudangProvider>(context, listen: false)
        .getGudangAll();
    setState(() {
      HomePage.listGudangNotifier.value = listGudang;
    });
  }

  Future _getKategori() async {
    final listKategori =
        await Provider.of<KategoriProvider>(context, listen: false)
            .getKategoriAll();
    setState(() {
      HomePage.listKategoriNotifier.value = listKategori;
    });
  }

  void popupAction(String tipe, String contentText, Antrian antrian) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              tipe,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
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
                  if (tipe.toLowerCase() == "mulai persiapan") {
                    actionMulaiPersiapan(antrian);
                    Navigator.of(context).pop();
                  } else if (tipe.toLowerCase() == "mulai bongkar") {
                    actionMulaiBongkar(antrian);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void goAction(String tombol, Antrian antrian) {
    if (tombol.isEmpty || antrian.uid.isEmpty) {
      Get.snackbar("Error", "Data antrian tidak boleh kosong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      if (tombol.toString().toLowerCase() == "konfirmasi\nsupir") {
        actionKonfirmasi(antrian);
      } else if (tombol.toString().toLowerCase() == "mulai\npersiapan") {
        popupAction(
            "Mulai Persiapan",
            "Mulai persiapan antrian dengan nomor polisi ${antrian.nopol.toUpperCase()}\njenis kendaraan ${antrian.typeKendaraan.toUpperCase()}?",
            antrian);
        // actionMulaiPersiapan(antrian);
      } else if (tombol.toString().toLowerCase() == "selesai\npersiapan") {
        actionSelesaiPersiapan(antrian);
      } else if (tombol.toString().toLowerCase() == "mulai\nbongkar") {
        popupAction(
            "Mulai Bongkar",
            "Mulai bongkar antrian dengan nomor polisi ${antrian.nopol.toUpperCase()}\njenis kendaraan ${antrian.typeKendaraan.toUpperCase()}?",
            antrian);
        // actionMulaiBongkar(antrian);
      } else if (tombol.toString().toLowerCase() == "selesai\nbongkar") {
        actionSelesaiBongkar(antrian);
      }
    }
  }

  void actionKonfirmasi(Antrian antrian) {
    KonfirmasiAction()
        .konfirmasi(widget.currentUser.token, antrian.uid)
        .then((value) {
      // if (value.statusCode == 200) {
      var responseBody = value.body;
      // if ((responseBody['success'].toString().toLowerCase() == "true") &&
      //     (selectedGudang.namaGudang != "")) {
      //   _getDataListAntrian(selectedGudang.namaGudang);
      if ((responseBody['success'].toString().toLowerCase() == "true")) {
        _getDataListAntrian();
      } else {
        if (responseBody['message'].toString() != "") {
          Get.snackbar("Gagal Konfirmasi", responseBody['message'].toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal melakukan konfirmasi", "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
      // } else {
      //   Get.snackbar("Gagal", "Gagal melakukan konfirmasi",
      //       backgroundColor: Colors.red, colorText: Colors.white);
      // }
    });
  }

  void actionMulaiPersiapan(Antrian antrian) {
    PersiapanAction()
        .mulaiPersiapan(widget.currentUser.token, antrian.uid)
        .then((value) {
      // if (value.statusCode == 200) {
      var responseBody = value.body;
      // if ((responseBody['success'].toString().toLowerCase() == "true") &&
      //     (selectedGudang.namaGudang != "")) {
      //   _getDataListAntrian(selectedGudang.namaGudang);
      if ((responseBody['success'].toString().toLowerCase() == "true")) {
        _getDataListAntrian();
      } else {
        if (responseBody['message'].toString() != "") {
          Get.snackbar(
              "Gagal Mulai Persiapan", responseBody['message'].toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal memulai persiapan", "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
      // } else {
      //   // Get.snackbar("Gagal", "Gagal memulai persiapan",
      //   //     backgroundColor: Colors.red, colorText: Colors.white);
      // }
    });
  }

  void actionSelesaiPersiapan(Antrian antrian) {
    PersiapanAction()
        .selesaiPersiapan(widget.currentUser.token, antrian.uid)
        .then((value) {
      // if (value.statusCode == 200) {
      var responseBody = value.body;
      // if ((responseBody['success'].toString().toLowerCase() == "true") &&
      //     (selectedGudang.namaGudang != "")) {
      //   _getDataListAntrian(selectedGudang.namaGudang);
      if ((responseBody['success'].toString().toLowerCase() == "true")) {
        _getDataListAntrian();
      } else {
        if (responseBody['message'].toString() != "") {
          Get.snackbar(
              "Gagal Selesai Persiapan", responseBody['message'].toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal menyelesaikan persiapan", "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
      // } else {
      //   // Get.snackbar("Gagal", "Gagal menyelesaikan persiapan",
      //   //     backgroundColor: Colors.red, colorText: Colors.white);
      // }
    });
  }

  void actionMulaiBongkar(Antrian antrian) {
    BongkarAction()
        .mulaiBongkar(widget.currentUser.token, antrian.uid)
        .then((value) {
      // if (value.statusCode == 200) {
      var responseBody = value.body;
      // if ((responseBody['success'].toString().toLowerCase() == "true") &&
      //     (selectedGudang.namaGudang != "")) {
      if ((responseBody['success'].toString().toLowerCase() == "true")) {
        var durasi = DateFormat("HH:mm:ss").parse("00:${antrian.estimasi}");
        widget.listWaktuAntrian.add(AntrianTimerCountUp(
            uid: antrian.uid,
            nomor: antrian.nomor,
            waktuBongkar: DateFormat('Hms').format(DateTime.now()),
            estimasi: "00:${antrian.estimasi}",
            waktuBatasBongkar: DateFormat('Hms')
                .format(DateTime.now().add(Duration(minutes: durasi.minute)))));
        String jsonWaktuAntrian = jsonEncode(widget.listWaktuAntrian);
        SpUtil.putString('listWaktuAntrian', jsonWaktuAntrian);
        _getDataListAntrian();
      } else {
        if (responseBody['message'].toString() != "") {
          Get.snackbar(
              "Gagal Mulai Bongkar", responseBody['message'].toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal memulai bongkar", "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
      // } else {
      //   // Get.snackbar("Gagal", "Gagal memulai bongkar",
      //   //     backgroundColor: Colors.red, colorText: Colors.white);
      // }
    });
  }

  void actionSelesaiBongkar(Antrian antrian) {
    BongkarAction()
        .selesaiBongkar(widget.currentUser.token, antrian.uid)
        .then((value) {
      // if (value.statusCode == 200) {
      var responseBody = value.body;
      // if ((responseBody['success'].toString().toLowerCase() == "true") &&
      //     (selectedGudang.namaGudang != "")) {
      if ((responseBody['success'].toString().toLowerCase() == "true")) {
        var index = widget.listWaktuAntrian
            .indexWhere((item) => item.uid == antrian.uid);
        if (index > -1) {
          widget.listWaktuAntrian.removeAt(index);
        }
        String jsonWaktuAntrian = jsonEncode(widget.listWaktuAntrian);
        SpUtil.putString('listWaktuAntrian', jsonWaktuAntrian);
        _getDataListAntrian();
      } else {
        if (responseBody['message'].toString() != "") {
          Get.snackbar(
              "Gagal Selesai Bongkar", responseBody['message'].toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal Selesai Bongkar", "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
      // } else {
      //   // Get.snackbar("Gagal", "Gagal menyelesaikan bongkar",
      //   //     backgroundColor: Colors.red, colorText: Colors.white);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: HeaderPage(user: widget.currentUser)),
          Expanded(
              flex: 4,
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      // debugPrint("Get Data Antrian");
                      _getDataListAntrian();
                    },
                  );
                },
                child: CustomScrollView(slivers: <Widget>[
                  SliverFillRemaining(child: listAntrian(context))
                ]),
              )),
          Expanded(
              flex: 1,
              child: Container(
                  color: kWhite,
                  child: profileUser(context, widget.currentUser))),
        ],
      ),
    );
  }

  Container profileUser(BuildContext context, User user) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      padding: const EdgeInsets.only(
          left: kDefaultPadding / 3, right: kDefaultPadding / 3, top: 0),
      decoration: const BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(15), bottom: Radius.circular(0)),
      ),
      child: Row(
        children: [
          // const Expanded(
          //   flex: 1,
          //   child: CircleAvatar(
          //       backgroundColor: kRedBold,
          //       child: Icon(
          //         Icons.person,
          //         color: kWhite,
          //       )),
          // ),
          // Expanded(
          //   flex: 3,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 5),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text("Nama Petugas",
          //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                 color: kTextWhiteColor,
          //                 fontWeight: FontWeight.normal,
          //                 fontSize: 12.sp,
          //                 letterSpacing: 0)),
          //         SizedBox(
          //           height: 1.w,
          //         ),
          //         Text(widget.currentUser.name,
          //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                 color: kTextWhiteColor,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 12.sp,
          //                 letterSpacing: 0)),
          //       ],
          //     ),
          //   ),
          // ),
          // Expanded(
          //   flex: 3,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 5),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text("Jenis Gudang",
          //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
          //                 fontSize: 11.sp,
          //                 color: kWhite,
          //                 fontWeight: FontWeight.normal,
          //                 letterSpacing: 0)),
          //         SizedBox(
          //           height: 1.w,
          //         ),
          //         FilterButton(
          //             text: selectedGudang.namaGudang != ""
          //                 ? selectedGudang.namaGudang
          //                 : "Pilih Gudang",
          //             press: () {
          //               if (_timerGetData.isActive) {
          //                 _timerGetData.cancel();
          //               }
          //               _getGudang();
          //               showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return ValueListenableBuilder<ListGudang>(
          //                         valueListenable: HomePage.listGudangNotifier,
          //                         builder: (context, value, child) {
          //                           final listData = value.gudangs;
          //                           return AlertDialog(
          //                               contentPadding: EdgeInsets.zero,
          //                               content: Container(
          //                                 padding: EdgeInsets.only(
          //                                     bottom: MediaQuery.of(context)
          //                                             .size
          //                                             .height /
          //                                         30),
          //                                 width: MediaQuery.of(context)
          //                                         .size
          //                                         .width /
          //                                     3,
          //                                 height: MediaQuery.of(context)
          //                                         .size
          //                                         .height /
          //                                     2,
          //                                 child: Column(
          //                                   children: [
          //                                     Padding(
          //                                       padding: EdgeInsets.symmetric(
          //                                           vertical:
          //                                               MediaQuery.of(context)
          //                                                       .size
          //                                                       .height /
          //                                                   40),
          //                                       child: Text(
          //                                         "Pilih Jenis Gudang",
          //                                         style: Theme.of(context)
          //                                             .textTheme
          //                                             .bodyMedium!
          //                                             .copyWith(
          //                                                 color: kRedBold,
          //                                                 fontSize: 12.sp,
          //                                                 fontWeight:
          //                                                     FontWeight.bold),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                     SizedBox(
          //                                       height: MediaQuery.of(context)
          //                                               .size
          //                                               .height /
          //                                           3,
          //                                       child: Scrollbar(
          //                                         thumbVisibility: true,
          //                                         radius:
          //                                             const Radius.circular(5),
          //                                         interactive: true,
          //                                         child: ListView.builder(
          //                                           scrollDirection:
          //                                               Axis.vertical,
          //                                           shrinkWrap: true,
          //                                           itemCount: listData.length,
          //                                           itemBuilder: (_, i) {
          //                                             return InkWell(
          //                                               onTap: () {
          //                                                 setState(() {
          //                                                   selectedGudang =
          //                                                       listData[i];
          //                                                 });
          //                                                 _getDataListAntrian(
          //                                                     selectedGudang
          //                                                         .namaGudang);
          //                                                 setUpTimedFetchDatabyGudang(
          //                                                     selectedGudang
          //                                                         .namaGudang);
          //                                                 Navigator.of(context)
          //                                                     .pop();
          //                                               },
          //                                               child: Padding(
          //                                                 padding: EdgeInsets.symmetric(
          //                                                     horizontal:
          //                                                         MediaQuery.of(
          //                                                                     context)
          //                                                                 .size
          //                                                                 .width /
          //                                                             40),
          //                                                 child: Card(
          //                                                   margin:
          //                                                       const EdgeInsets
          //                                                           .all(2),
          //                                                   shape: RoundedRectangleBorder(
          //                                                       borderRadius:
          //                                                           BorderRadius
          //                                                               .circular(
          //                                                                   5)),
          //                                                   elevation: 0,
          //                                                   color: kGreyList,
          //                                                   child: Padding(
          //                                                     padding: EdgeInsets.only(
          //                                                         top: MediaQuery.of(
          //                                                                     context)
          //                                                                 .size
          //                                                                 .height /
          //                                                             80,
          //                                                         bottom: MediaQuery.of(
          //                                                                     context)
          //                                                                 .size
          //                                                                 .height /
          //                                                             80,
          //                                                         left: MediaQuery.of(
          //                                                                     context)
          //                                                                 .size
          //                                                                 .width /
          //                                                             40),
          //                                                     child: Text(
          //                                                       listData[i]
          //                                                           .namaGudang,
          //                                                       style: Theme.of(
          //                                                               context)
          //                                                           .textTheme
          //                                                           .bodyMedium!
          //                                                           .copyWith(
          //                                                               color:
          //                                                                   kBrown,
          //                                                               fontSize: 12
          //                                                                   .sp,
          //                                                               fontWeight:
          //                                                                   FontWeight.bold),
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .left,
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                               ),
          //                                             );
          //                                           },
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ));
          //                         });
          //                   });
          //             },
          //             backColor: kRedBold,
          //             borderColor: kWhite,
          //             textColor: kWhite,
          //             ikon: Icons.arrow_drop_down,
          //             fontSizeValue: 10)
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text("Jenis Kategori",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 10.sp,
                                    color: kTextWhiteColor,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0)),
                      ),
                      // Expanded(
                      //   flex: 2,
                      //   child: InkWell(
                      //     onTap: () {
                      //       setState(() {
                      //         // String listWaktuAntrian =
                      //         //     jsonEncode(widget.listWaktuAntrian);
                      //         // debugPrint(
                      //         //     'listWaktuAntrian IN = $listWaktuAntrian');
                      //         selectedKategori =
                      //             Kategori(idKategori: "", namaKategori: "");
                      //       });
                      //     },
                      //     child: Container(
                      //       // alignment: Alignment.centerLeft,
                      //       decoration: const BoxDecoration(
                      //           color: kRedBold,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(4))),
                      //       padding: EdgeInsets.symmetric(
                      //           vertical:
                      //               MediaQuery.of(context).size.height / 200),
                      //       child: Row(
                      //         // crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Icon(
                      //             Icons.replay,
                      //             // size: 12,
                      //             size: 7.sp,
                      //             color: kWhite,
                      //           ),
                      //           Text(
                      //             "Reset",
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .bodySmall!
                      //                 .copyWith(
                      //                     color: kWhite,
                      //                     fontWeight: FontWeight.normal,
                      //                     fontSize: 7.sp,
                      //                     letterSpacing: 0),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  FilterButton(
                      // text: selectedKategori.namaKategori != ""
                      //     ? selectedKategori.namaKategori
                      //     : "G SUPPORT MATERIAL", //"Pilih Kategori",
                      text: user.kategori,
                      press: () {},
                      // press: () {
                      //   if (selectedGudang.namaGudang != "") {
                      //     if (_timerGetData.isActive) {
                      //       _timerGetData.cancel();
                      //       // debugPrint("_timerGetData CANCEL");
                      //     }
                      //     _getKategori();
                      //     showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return ValueListenableBuilder<ListKategori>(
                      //               valueListenable:
                      //                   HomePage.listKategoriNotifier,
                      //               builder: (context, value, child) {
                      //                 final listData = value.kategoris;
                      //                 return AlertDialog(
                      //                     contentPadding: EdgeInsets.zero,
                      //                     content: Container(
                      //                       padding: EdgeInsets.only(
                      //                           bottom: MediaQuery.of(context)
                      //                                   .size
                      //                                   .height /
                      //                               30),
                      //                       width: MediaQuery.of(context)
                      //                               .size
                      //                               .width /
                      //                           3,
                      //                       height: MediaQuery.of(context)
                      //                               .size
                      //                               .height /
                      //                           2,
                      //                       child: Column(
                      //                         children: [
                      //                           Padding(
                      //                             padding: EdgeInsets.symmetric(
                      //                                 vertical:
                      //                                     MediaQuery.of(context)
                      //                                             .size
                      //                                             .height /
                      //                                         40),
                      //                             child: Text(
                      //                               "Pilih Kategori",
                      //                               style: Theme.of(context)
                      //                                   .textTheme
                      //                                   .bodyMedium!
                      //                                   .copyWith(
                      //                                       color: kRedBold,
                      //                                       fontWeight:
                      //                                           FontWeight.bold,
                      //                                       fontSize: 12.sp),
                      //                               textAlign: TextAlign.center,
                      //                             ),
                      //                           ),
                      //                           SizedBox(
                      //                             height: MediaQuery.of(context)
                      //                                     .size
                      //                                     .height /
                      //                                 3,
                      //                             child: Scrollbar(
                      //                               thumbVisibility: true,
                      //                               radius:
                      //                                   const Radius.circular(
                      //                                       5),
                      //                               interactive: true,
                      //                               child: ListView.builder(
                      //                                 scrollDirection:
                      //                                     Axis.vertical,
                      //                                 shrinkWrap: true,
                      //                                 itemCount:
                      //                                     listData.length,
                      //                                 itemBuilder: (_, i) {
                      //                                   return InkWell(
                      //                                     onTap: () {
                      //                                       setState(() {
                      //                                         selectedKategori =
                      //                                             listData[i];
                      //                                       });
                      //                                       _getDataListAntrian(
                      //                                           selectedGudang
                      //                                               .namaGudang);
                      //                                       setUpTimedFetchDatabyGudang(
                      //                                           selectedGudang
                      //                                               .namaGudang);
                      //                                       Navigator.of(
                      //                                               context)
                      //                                           .pop();
                      //                                     },
                      //                                     child: Padding(
                      //                                       padding: EdgeInsets.symmetric(
                      //                                           horizontal: MediaQuery.of(
                      //                                                       context)
                      //                                                   .size
                      //                                                   .width /
                      //                                               40),
                      //                                       child: Card(
                      //                                         margin:
                      //                                             const EdgeInsets
                      //                                                 .all(2),
                      //                                         shape: RoundedRectangleBorder(
                      //                                             borderRadius:
                      //                                                 BorderRadius
                      //                                                     .circular(
                      //                                                         5)),
                      //                                         elevation: 0,
                      //                                         color: kGreyList,
                      //                                         child: Padding(
                      //                                           padding: EdgeInsets.only(
                      //                                               top: MediaQuery.of(context)
                      //                                                       .size
                      //                                                       .height /
                      //                                                   80,
                      //                                               bottom: MediaQuery.of(context)
                      //                                                       .size
                      //                                                       .height /
                      //                                                   80,
                      //                                               left: MediaQuery.of(context)
                      //                                                       .size
                      //                                                       .width /
                      //                                                   40),
                      //                                           child: Text(
                      //                                             listData[i]
                      //                                                 .namaKategori,
                      //                                             style: Theme.of(
                      //                                                     context)
                      //                                                 .textTheme
                      //                                                 .bodyMedium!
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         kBrown,
                      //                                                     fontSize: 12
                      //                                                         .sp,
                      //                                                     fontWeight:
                      //                                                         FontWeight.bold),
                      //                                             textAlign:
                      //                                                 TextAlign
                      //                                                     .left,
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   );
                      //                                 },
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ));
                      //               });
                      //         });
                      //   }
                      // },
                      backColor: kRedBold,
                      borderColor: kRedBold,
                      textColor: kWhite,
                      ikon: Icons.label_important,
                      fontSizeValue: 10)
                ],
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: ValueListenableBuilder<ListAntrian>(
                  valueListenable: HomePage.listAntrianNotifier,
                  builder: (context, value, child) {
                    var dataStatistik = value.statistik;
                    if (dataStatistik.isEmpty) {
                      dataStatistik = [
                        Statistik(antrian: "0", selesai: "0", bongkar: "0")
                      ];
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 45),
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 35,
                          // right: kDefaultPadding / 10,
                          // top: kDefaultPadding / 4,
                          bottom: 0),
                      decoration: const BoxDecoration(
                          color: kRedBold,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Antri",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10.sp,
                                          letterSpacing: 0),
                                ),
                                Text(
                                  dataStatistik[0].antrian,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          letterSpacing: 0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Proses",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10.sp,
                                          letterSpacing: 0),
                                ),
                                Text(
                                  dataStatistik[0].bongkar,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          letterSpacing: 0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Selesai",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10.sp,
                                          letterSpacing: 0),
                                ),
                                Text(
                                  dataStatistik[0].selesai,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          letterSpacing: 0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  })),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 80),
              child: RoundedButton(
                  text: "data report",
                  textSize: 10,
                  heightDivide: 8,
                  radius: 10,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppLayout(
                                  currentUser: widget.currentUser,
                                  selectedMenu: 1,
                                  currentLog: widget.listWaktuAntrian,
                                )));
                    // if (_timerGetData.isActive) {
                    //   _timerGetData.cancel();
                    // }
                  },
                  backColor: kOrange,
                  textColor: kWhite),
            ),
          )
        ],
      ),
    );
  }

  Container listAntrian(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 200,
            right: MediaQuery.of(context).size.width / 200,
            top: MediaQuery.of(context).size.width / 100),
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(30), bottom: Radius.circular(0)),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // CellHeaderText(
                //   teks: "No",
                //   containerAlign: Alignment.bottomCenter,
                //   teksAlign: TextAlign.center,
                //   flexValue: 2,
                // ),
                CellHeaderText(
                  teks: "ANTRIAN",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 4,
                ),
                CellHeaderText(
                  teks: "NOPOL",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 7,
                ),
                CellHeaderText(
                  teks: "NO.HP",
                  containerAlign: Alignment.bottomLeft,
                  teksAlign: TextAlign.left,
                  flexValue: 6,
                ),
                // CellHeaderText(
                //   teks: "KATEGORI",
                //   containerAlign: Alignment.bottomLeft,
                //   teksAlign: TextAlign.left,
                //   flexValue: 5,
                // ),
                CellHeaderText(
                  teks: "GDN",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 2,
                ),
                CellHeaderText(
                  teks: "DAFTAR",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 4,
                ),
                CellHeaderText(
                  teks: "STATUS",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 5,
                ),
                CellHeaderText(
                  teks: "",
                  containerAlign: Alignment.bottomLeft,
                  teksAlign: TextAlign.left,
                  flexValue: 4,
                ),
                CellHeaderText(
                  teks: "AKSI",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 6,
                ),
              ]),
            ),
            Expanded(
                flex: 5,
                // child: _buildAllAntrianList(context),
                child: RefreshIndicator(
                  child: _buildAllAntrianList(context),
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        // debugPrint("Get Data Antrian");
                        _getDataListAntrian();
                      },
                    );
                  },
                )),
          ],
        ));
  }

  Widget _buildAllAntrianList(BuildContext context) {
    return ValueListenableBuilder<ListAntrian>(
      valueListenable: HomePage.listAntrianNotifier,
      builder: (context, value, child) {
        List<Antrian> listAntrian = value.antrians;

        // // Filter Kategori
        // if (selectedKategori.namaKategori != "") {
        //   listAntrian = listAntrian
        //       .where((element) => element.kategori
        //           .toUpperCase()
        //           .contains(selectedKategori.namaKategori.toUpperCase()))
        //       .toList();
        // }

        // // Filter Gudang
        // if (selectedGudang.namaGudang != "") {
        //   listAntrian = listAntrian
        //       .where((element) =>
        //           element.gudang.contains(selectedGudang.namaGudang))
        //       .toList();
        // }

        // if (HomePage.messageAntrianNotifier == "" ||
        //     HomePage.messageAntrianNotifier == "Empty Data") {
        if (listAntrian.isEmpty) {
          // if (selectedGudang.namaGudang == "") {
          //   return Center(
          //       child: Container(
          //     padding: EdgeInsets.symmetric(
          //         vertical: MediaQuery.of(context).size.height / 30),
          //     child: Column(
          //       children: [
          //         Expanded(
          //           flex: 4,
          //           child: SvgPicture.asset(
          //             'assets/images/Select-amico.svg',
          //             fit: BoxFit.contain,
          //             width: MediaQuery.of(context).size.width,
          //           ),
          //         ),
          //         Expanded(
          //           child: Text('Silahkan pilih Gudang terlebih dahulu',
          //               textAlign: TextAlign.center,
          //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                   color: kRedBold,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 12.sp)),
          //         ),
          //       ],
          //     ),
          //   ));
          // } else {
          if (HomePage.messageAntrianNotifier == "" ||
              HomePage.messageAntrianNotifier == "Empty Data") {
            return Center(
                child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 30),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/images/Empty-bro.svg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        'Data antrian kosong\nTidak ada data yang ditampilkan',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kRedBold,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp)),
                  ),
                ],
              ),
            ));
          } else {
            return Center(
                child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 30),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/images/No connection-bro.svg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "Koneksi internet sedang tidak stabil\natau Koneksi ke server terputus",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kRedBold,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp)),
                  ),
                ],
              ),
            ));
          }
          // }
        } else {
          return Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              radius: const Radius.circular(5),
              interactive: true,
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: listAntrian.length,
                itemBuilder: (context, index) {
                  int noUrut = index + 1;
                  return _buildAntrianItem(context, listAntrian.length,
                      noUrut.toString(), listAntrian[index]);
                },
              ));
        }
        // } else {
        //   return Center(
        //       child: Container(
        //     padding: EdgeInsets.symmetric(
        //         vertical: MediaQuery.of(context).size.height / 30),
        //     child: Column(
        //       children: [
        //         Expanded(
        //           flex: 4,
        //           child: SvgPicture.asset(
        //             'assets/images/No connection-bro.svg',
        //             width: MediaQuery.of(context).size.width,
        //             fit: BoxFit.contain,
        //           ),
        //         ),
        //         Expanded(
        //           flex: 1,
        //           child: Text(
        //               "Koneksi internet sedang tidak stabil\natau Koneksi ke server terputus",
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                   color: kRedBold,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 12.sp)),
        //         ),
        //       ],
        //     ),
        //   ));
        // }
      },
    );
  }

  Widget _buildAntrianItem(
      BuildContext context, int total, String noUrut, Antrian dataAntrian) {
    String formatDuration(Duration duration) {
      String hours;
      String minutes;
      String seconds;

      if (duration.isNegative) {
        // hours = "00";
        // minutes = "00";
        // seconds = "00";
        hours = duration.inHours.toString().substring(1).padLeft(2, '0');
        minutes = duration.inMinutes
            .remainder(60)
            .toString()
            .substring(1)
            .padLeft(2, '0');
        seconds = duration.inSeconds
            .remainder(60)
            .toString()
            .substring(1)
            .padLeft(2, '0');
        return "+$hours:$minutes:$seconds";
      } else {
        hours = duration.inHours.toString().padLeft(0, '2');
        minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
        seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        return "$hours:$minutes:$seconds";
      }
      // return "$hours:$minutes:$seconds";
    }

    // var waktuBongkar = DateTime.now();
    var waktuBatasBongkar = DateTime.now();
    var durasiMenunggu = "-";
    // var durasi = const Duration(
    //   seconds: 0,
    //   minutes: 0,
    //   hours: 0,
    // );
    var batasWaktu = const Duration(seconds: 0);
    var waktuSekarang = _timeNow.toString() != "-" || _timeNow != ""
        ? DateFormat("HH:mm:ss").parse(_timeNow.toString())
        : DateTime.now();
    var dataWaktu =
        widget.listWaktuAntrian.where((f) => f.uid == dataAntrian.uid);
// debugPrint("listWaktuAntrian : ${jsonEncode(widget.listWaktuAntrian).toString()}");
    if (dataWaktu.isNotEmpty) {
      // waktuBongkar = DateFormat("HH:mm:ss").parse(dataWaktu.first.waktuBongkar);
      waktuBatasBongkar =
          DateFormat("HH:mm:ss").parse(dataWaktu.first.waktuBatasBongkar);
      durasiMenunggu =
          formatDuration(waktuBatasBongkar.difference(waktuSekarang));
      // durasi = waktuBatasBongkar.difference(waktuSekarang);
      batasWaktu = waktuSekarang.difference(waktuBatasBongkar);
    }

    return Card(
      margin: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: dataAntrian.button.toUpperCase() == "SELESAI"
          ? kGreen
          : batasWaktu.inSeconds >= 1
              ? kOrange
              : kGreyList,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CellText(
          //   teks: noUrut.toUpperCase(),
          //   teksFont: 8,
          //   teksAlign: TextAlign.center,
          //   teksColor:
          //       dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
          //   blockColor: Colors.transparent,
          //   containerAlign: Alignment.center,
          //   flexValue: 2,
          // ),
          CellText(
            teks: dataAntrian.nomor.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 4,
          ),
          CellText(
            teks:
                "${dataAntrian.nopol.toUpperCase()}\n ${dataAntrian.typeKendaraan.toUpperCase()}",
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kWhite,
            blockColor: kGreen,
            containerAlign: Alignment.center,
            flexValue: 7,
          ),
          CellText(
            teks: dataAntrian.nohp.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.left,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.centerLeft,
            flexValue: 6,
          ),
          // CellText(
          //   teks: dataAntrian.kategori.toUpperCase(),
          //   teksFont: 7,
          //   teksAlign: TextAlign.left,
          //   teksColor:
          //       dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
          //   blockColor: Colors.transparent,
          //   containerAlign: Alignment.centerLeft,
          //   flexValue: 5,
          // ),
          CellText(
            teks: dataAntrian.gudang.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 2,
          ),
          CellText(
            teks: dataAntrian.pendaftaran.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 4,
          ),
          CellText(
            teks: dataAntrian.status.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor:
                dataAntrian.button.toUpperCase() == "SELESAI" ? kWhite : kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 5,
          ),
          CellText(
            teks: dataAntrian.button.toUpperCase() == "SELESAI"
                ? "-"
                : durasiMenunggu.toString() == "00:00:00"
                    ? "-"
                    : durasiMenunggu.toString(),
            teksFont: 8,
            teksAlign: TextAlign.center,
            teksColor: kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 4,
          ),
          Expanded(
            flex: 6,
            child: ActionButton(
              text: dataAntrian.button.replaceAll(RegExp(r"\s+\b|\b\s"), "\n"),
              // press: () => goAction(dataAntrian.button, dataAntrian),
              press: () async {
                // debugPrint("Button Click ID ${dataAntrian.toString()}");
                pingConnection(
                    dataAntrian.button, dataAntrian, widget.currentUser);
              },
              fontSizeValue: 7,
              antrian: dataAntrian,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderPage extends StatelessWidget {
  HeaderPage({
    super.key,
    required this.user,
  });

  final User user;
  // final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 35,
              right: MediaQuery.of(context).size.width / 70),
          child: Image.asset(
            'assets/images/Logo-Santos-polos.png',
            width: 30.sp,
            filterQuality: FilterQuality.medium,
          ),
          //   InkWell(
          //   onTap: () => settingDialog(context),
          //   child: Image.asset(
          //     'assets/images/Logo-Santos-polos.png',
          //     width: 30.sp,
          //     filterQuality: FilterQuality.medium,
          //   ),
          //   // SvgPicture.asset(
          //   //   'assets/images/Logo-Santos-polos.png'
          //   // ),
          // ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            user.sja.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kTextBlackColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                letterSpacing: 0),
          ),
        ),
        // Expanded(
        //   flex: 6,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         user.sja.toUpperCase(),
        //         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //             color: kTextBlackColor,
        //             fontWeight: FontWeight.bold,
        //             fontSize: 12.sp,
        //             letterSpacing: 0),
        //       ),
        //       SizedBox(height: MediaQuery.of(context).size.height/120,),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           // Expanded(
        //           //   flex: 1,
        //           //   child: CircleAvatar(
        //           //       radius: 9.sp,
        //           //       backgroundColor: kRedBold,
        //           //       child: Icon(
        //           //         size: 12.sp,
        //           //         Icons.person,
        //           //         color: kWhite,
        //           //       )),
        //           // ),
        //           Expanded(
        //             flex: 1,
        //             child: Icon(
        //               size: 15.sp,
        //               Icons.account_circle,
        //               color: kBlack,
        //             ),
        //           ),
        //           Expanded(
        //             flex: 15,
        //             child: Text(
        //               user.name.toUpperCase(),
        //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                   color: kTextBlackColor,
        //                   fontWeight: FontWeight.normal,
        //                   fontSize: 11.sp,
        //                   letterSpacing: 0),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(
        //   flex: 6,
        //   child: Text(
        //     user.name.toUpperCase(),
        //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //         color: kTextBlackColor,
        //         fontWeight: FontWeight.normal,
        //         fontSize: 11.sp,
        //         letterSpacing: 0),
        //   ),
        // ),
        // Expanded(
        //   flex: 1,
        //   child: Icon(
        //     size: 15.sp,
        //     Icons.account_circle,
        //     color: kBlack,
        //   ),
        // ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "${user.name.substring(0, 1).toUpperCase()}${user.name.substring(1, user.name.length).toLowerCase()}",
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kTextBlackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                      letterSpacing: 0),
                ),
              ),
              Icon(
                size: 22.sp,
                Icons.account_circle,
                color: kBlack,
              ),
              // CircleAvatar(
              //     radius: 9.sp,
              //     backgroundColor: kRedBold,
              //     child: Icon(
              //       size: 12.sp,
              //       Icons.person,
              //       color: kWhite,
              //     )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 120,
              ),
              InkWell(
                onTap: () {
                  logoutDialog(
                      context,
                      "Logout",
                      "${user.name.substring(0, 1).toUpperCase()}${user.name.substring(1, user.name.length).toLowerCase()}, Apakah anda yakin ingin logout?",
                      user);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 100,
                      right: MediaQuery.of(context).size.width / 35),
                  child: Icon(
                    Icons.logout,
                    color: kRedBold,
                    size: 15.sp,
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     logoutDialog(context, "Logout",
              //         "${user.name}, Apakah anda yakin ingin logout?", user);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //         left: kDefaultPadding / 3, right: kDefaultPadding),
              //     child: Text(
              //       "Logout",
              //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
              //           color: kRedBold,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 10.sp,
              //           letterSpacing: 0),
              //     ),
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}

class CellHeaderText extends StatelessWidget {
  String teks;
  TextAlign teksAlign;
  AlignmentGeometry containerAlign;
  int flexValue;

  CellHeaderText({
    required this.teks,
    required this.teksAlign,
    required this.containerAlign,
    required this.flexValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flexValue,
      child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 60),
        height: MediaQuery.of(context).size.height / 12,
        alignment: containerAlign,
        child: Text(
          teks,
          textAlign: teksAlign,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: kRed,
              fontSize: 8.sp,
              letterSpacing: 0),
        ),
      ),
    );
  }
}

class CellText extends StatelessWidget {
  String teks;
  int teksFont;
  TextAlign teksAlign;
  AlignmentGeometry containerAlign;
  int flexValue;
  Color teksColor;
  Color blockColor;

  CellText({
    required this.teks,
    required this.teksFont,
    required this.teksAlign,
    required this.teksColor,
    required this.blockColor,
    required this.containerAlign,
    required this.flexValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flexValue,
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        decoration: BoxDecoration(
          color: blockColor,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(5), bottom: Radius.circular(5)),
        ),
        // color: blockColor,
        height: MediaQuery.of(context).size.height / 11,
        alignment: containerAlign,
        child: Text(
          teks,
          textAlign: teksAlign,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: teksColor,
              letterSpacing: 0,
              fontSize: teksFont.sp),
        ),
      ),
    );
  }
}
