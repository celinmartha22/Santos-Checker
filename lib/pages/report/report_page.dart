import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/controllers/network_connectivity_controller.dart';
import 'package:santos_checker/data/helpers/device_connection_helper.dart';
import 'package:santos_checker/data/model/gudang.dart';
import 'package:santos_checker/data/model/kategori.dart';
import 'package:santos_checker/data/model/report.dart';
import 'package:santos_checker/data/model/user.dart';
import 'package:santos_checker/data/provider/report_provider.dart';
import 'package:santos_checker/pages/home/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/report';
  static String messageReportNotifier = "";
  static final ValueNotifier<ListReport> listReportNotifier =
      ValueNotifier(ListReport(reports: [], statistik: []));
  static final ValueNotifier<ListGudang> listGudangNotifier =
      ValueNotifier(ListGudang(gudangs: []));
  static final ValueNotifier<ListKategori> listKategoriNotifier =
      ValueNotifier(ListKategori(kategoris: []));

  ReportPage({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool timerStarted = false;
  String version = "";
  late bool isConnectInternet = true;
  late bool isConnectServer = true;
  final Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _deviceConnectivity = NetworkConnectivity.instance;
  late List<Report> listAsisten;
  final ScrollController scrollController = ScrollController();
  // late Timer _timerClock;
  // late Timer _timerGetData = Timer(const Duration(seconds: 10), () {});
  // var _timeNow = DateFormat('Hms').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    checkDeviceConnection(context, _deviceConnectivity, _source);
    // startTimer();
    _getDataListReport();
    // setUpTimedFetchDatabyGudang();
  }

  @override
  void dispose() {
    // _timerClock.cancel();
    // _timerGetData.cancel();
    _deviceConnectivity.disposeStream();
    super.dispose();
  }

  // void startTimer() {
  //   _timerClock = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) {
  //       setState(() {
  //         _timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
  //       });
  //       // if (DateTime.now().second == 0 && _timerGetData.isActive) {
  //       //   _timerGetData.cancel();
  //       //   setUpTimedFetchDatabyGudang();
  //       // }
  //     },
  //   );
  // }

  // void stopGetData() {
  //   _timerClock = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) {
  //       setState(() {
  //         _timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
  //       });
  //     },
  //   );
  // }

  // setUpTimedFetchDatabyGudang() {
  //   _timerGetData = Timer.periodic(
  //     const Duration(seconds: 10),
  //     (timer) {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  //       _getDataListReport();
  //     },
  //   );
  // }

  Future _getDataListReport() async {
    final listReportData =
        await Provider.of<ReportProvider>(context, listen: false)
            .getReportAll(widget.currentUser.token);
    if (listReportData is String) {
      setState(() {
        ReportPage.messageReportNotifier = listReportData;
        ReportPage.listReportNotifier.value =
            ListReport(reports: [], statistik: []);
      });
    } else {
      setState(() {
        ReportPage.messageReportNotifier = "";
        ReportPage.listReportNotifier.value = listReportData;
      });
    }
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
                      // debugPrint("Get Data Report");
                      _getDataListReport();
                    },
                  );
                },
                child: CustomScrollView(slivers: <Widget>[
                  SliverFillRemaining(child: listReport(context))
                ]),
              )),
          // Expanded(flex: 4, child: listReport(context)),
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
            top: Radius.circular(20), bottom: Radius.circular(0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
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
                    ],
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  FilterButton(
                      text: user.kategori,
                      press: () {},
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
              child: ValueListenableBuilder<ListReport>(
                  valueListenable: ReportPage.listReportNotifier,
                  builder: (context, value, child) {
                    var dataStatistik = value.statistik;
                    if (dataStatistik.isEmpty) {
                      dataStatistik = [
                        StatistikReport(gudang: "0", jumlah: "0")
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
                                  "Jumlah Gudang",
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
                                  dataStatistik[0].gudang,
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
                                  "Jumlah Antrian",
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
                                  dataStatistik[0].jumlah,
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
                          // Expanded(
                          //   flex: 1,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       Text(
                          //         "Selesai",
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodySmall!
                          //             .copyWith(
                          //                 color: kTextWhiteColor,
                          //                 fontWeight: FontWeight.normal,
                          //                 fontSize: 10.sp,
                          //                 letterSpacing: 0),
                          //       ),
                          //       Text(
                          //         "0", //dataStatistik[0].selesai,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodyMedium!
                          //             .copyWith(
                          //                 color: kTextWhiteColor,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 12.sp,
                          //                 letterSpacing: 0),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  Container listReport(BuildContext context) {
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
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CellHeaderText(
                  teks: "ANTRIAN &\nGUDANG",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 4,
                ),
                CellHeaderText(
                  teks: "NOPOL &\nTIPE KENDARAAN",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 8,
                ),
                CellHeaderText(
                  teks: "DAFTAR",
                  containerAlign: Alignment.center,
                  teksAlign: TextAlign.center,
                  flexValue: 4,
                ),
                CellHeaderText(
                  teks: "BONGKAR s/d\nSELESAI",
                  containerAlign: Alignment.bottomCenter,
                  teksAlign: TextAlign.center,
                  flexValue: 6,
                ),
                CellHeaderText(
                  teks: "ESTIMASI\nDURASI & WAKTU",
                  containerAlign: Alignment.center,
                  teksAlign: TextAlign.center,
                  flexValue: 6,
                ),
                // CellHeaderText(
                //   teks: "ESTIMASI\nWAKTU",
                //   containerAlign: Alignment.center,
                //   teksAlign: TextAlign.center,
                //   flexValue: 4,
                // ),
                CellHeaderText(
                  teks: "REALISASI",
                  containerAlign: Alignment.center,
                  teksAlign: TextAlign.center,
                  flexValue: 4,
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
                        _getDataListReport();
                      },
                    );
                  },
                )),
            // Expanded(flex: 5, child: _buildAllAntrianList(context)),
          ],
        ));
  }

  Widget _buildAllAntrianList(BuildContext context) {
    return ValueListenableBuilder<ListReport>(
      valueListenable: ReportPage.listReportNotifier,
      builder: (context, value, child) {
        List<Report> listReport = value.reports;
        if (listReport.isEmpty) {
          if (ReportPage.messageReportNotifier == "" ||
              ReportPage.messageReportNotifier == "Empty Data") {
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
              itemCount: listReport.length,
              itemBuilder: (context, index) {
                int noUrut = index + 1;
                return _buildAntrianItem(context, listReport.length,
                    noUrut.toString(), listReport[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildAntrianItem(
      BuildContext context, int total, String noUrut, Report dataReport) {
    var waktuEstimasi = DateTime.now();
    var waktuRealisasi = DateTime.now();
    var kelebihanWaktu = const Duration(seconds: 0);
    var hematWaktu = const Duration(seconds: 0);
    waktuEstimasi = dataReport.estimasi != ""
        ? dataReport.estimasi != "-"
            ? DateFormat("HH:mm:ss").parse(dataReport.estimasi)
            : DateFormat("HH:mm:ss").parse("00:00:00")
        : DateFormat("HH:mm:ss").parse("00:00:00");

    waktuRealisasi = DateFormat("HH:mm:ss").parse(dataReport.realisasi);
    kelebihanWaktu = waktuRealisasi.difference(waktuEstimasi);
    hematWaktu = waktuEstimasi.difference(waktuRealisasi);

    return Card(
      margin: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: kGreyList,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CellText(
            teks:
                "${dataReport.nomor.toUpperCase()}\n${dataReport.gudang.toUpperCase()}",
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor: kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 4,
            isDouble: false,
            teks2: "",
            blockColor2: Colors.transparent,
          ),
          CellText(
            teks:
                "${dataReport.nopol.toUpperCase()}\n${dataReport.typeKendaraan.toUpperCase()}",
            teksFont: 8,
            teksAlign: TextAlign.center,
            teksColor: kWhite,
            blockColor: kGreen,
            containerAlign: Alignment.center,
            flexValue: 8,
            isDouble: false,
            teks2: "",
            blockColor2: Colors.transparent,
          ),
          CellText(
            teks: dataReport.pendaftaran.toUpperCase(),
            teksFont: 7,
            teksAlign: TextAlign.center,
            teksColor: kBrown,
            blockColor: Colors.transparent,
            containerAlign: Alignment.center,
            flexValue: 4,
            isDouble: false,
            teks2: "",
            blockColor2: Colors.transparent,
          ),
          CellText(
            teks: dataReport.persiapan.toUpperCase(),
            teksFont: 8,
            teksAlign: TextAlign.center,
            teksColor: kWhite,
            blockColor: kBrown,
            containerAlign: Alignment.center,
            flexValue: 6,
            isDouble: true,
            teks2: dataReport.selesai.toUpperCase(),
            blockColor2: kBrownLight,
          ),
          CellText(
            teks: dataReport.estimasi,
            teksFont: 8,
            teksAlign: TextAlign.center,
            teksColor: kWhite,
            blockColor: kBrown,
            containerAlign: Alignment.center,
            flexValue: 6,
            isDouble: true,
            teks2: dataReport.batas,
            blockColor2: kBrownLight,
          ),
          // CellText(
          //   teks: dataReport.estimasi,
          //   teksFont: 8,
          //   teksAlign: TextAlign.center,
          //   teksColor: kBrown,
          //   blockColor: Colors.transparent,
          //   containerAlign: Alignment.center,
          //   flexValue: 4,
          //   isDouble: false,
          //   teks2: "",
          //   blockColor2: Colors.transparent,
          // ),
          CellText(
            // teks: dataReport.button.toUpperCase() == "SELESAI"
            //     ? "-"
            //     : durasiMenunggu.toString() == "00:00:00"
            //         ? "-"
            //         : durasiMenunggu.toString(),
            teks: dataReport.realisasi,
            teksFont: 8,
            teksAlign: TextAlign.center,
            // teksColor: kWhite,
            teksColor: kelebihanWaktu.inSeconds >= 1
                ? kWhite
                : hematWaktu.inSeconds >= 1
                    ? kWhite
                    : kBrown,
            // blockColor: kelebihanWaktu.inSeconds >= 1 ? kRed : kOrange,
            blockColor: kelebihanWaktu.inSeconds >= 1
                ? kRed
                : hematWaktu.inSeconds >= 1
                    ? kOrange
                    : kGreyList,
            containerAlign: Alignment.center,
            flexValue: 4,
            isDouble: false,
            teks2: "",
            blockColor2: Colors.transparent,
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
        ),
        Expanded(
          flex: 7,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: kTextBlackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  letterSpacing: 0),
              children: <TextSpan>[
                TextSpan(
                  text: "${user.sja.toUpperCase()}\n",
                ),
                TextSpan(
                    text: 'REPORT CHECKER',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                    )),
              ],
            ),
          ),
        ),
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 120,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 200,
                      right: MediaQuery.of(context).size.width / 35),
                  child: Icon(
                    Icons.home_rounded,
                    color: kRedBold,
                    size: 17.sp,
                  ),
                ),
              ),
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
        height: MediaQuery.of(context).size.height / 15,
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

  bool isDouble;
  String teks2;
  Color blockColor2;

  CellText({
    required this.teks,
    required this.teksFont,
    required this.teksAlign,
    required this.teksColor,
    required this.blockColor,
    required this.containerAlign,
    required this.flexValue,
    required this.isDouble,
    required this.teks2,
    required this.blockColor2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isDouble) {
      return Expanded(
        flex: flexValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 150,
                  bottom: MediaQuery.of(context).size.height / 200,
                  left: MediaQuery.of(context).size.width / 100,
                  right: MediaQuery.of(context).size.width / 100),
              decoration: BoxDecoration(
                color: blockColor,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5), bottom: Radius.circular(5)),
              ),
              height: MediaQuery.of(context).size.height / 30,
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
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 200,
                  left: MediaQuery.of(context).size.width / 100,
                  right: MediaQuery.of(context).size.width / 100),
              decoration: BoxDecoration(
                color: blockColor2,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5), bottom: Radius.circular(5)),
              ),
              height: MediaQuery.of(context).size.height / 30,
              alignment: containerAlign,
              child: Text(
                teks2,
                textAlign: teksAlign,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: teksColor,
                    letterSpacing: 0,
                    fontSize: teksFont.sp),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        flex: flexValue,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            color: blockColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5), bottom: Radius.circular(5)),
          ),
          height: MediaQuery.of(context).size.height / 14,
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
}
