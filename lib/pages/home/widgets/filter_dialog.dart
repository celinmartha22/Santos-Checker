import 'package:santos_checker/constants/style.dart';
import 'package:santos_checker/data/model/gudang.dart';
import 'package:santos_checker/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

filterDialog(BuildContext context, String tipe, String headerText,
    List<Gudang> listGudang) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<ListGudang>(
            valueListenable: HomePage.listGudangNotifier,
            builder: (context, value, child) {
              final listData = value.gudangs;
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 30),
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 40),
                          child: Text(
                            headerText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: kRedBold,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: const Radius.circular(5),
                            interactive: true,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listData.length,
                              itemBuilder: (_, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(listGudang[i]);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                40),
                                    child: Card(
                                      margin: const EdgeInsets.all(2),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      elevation: 0,
                                      color: kGreyList,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                40),
                                        child: Text(
                                          listGudang[i].namaGudang,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: kBrown,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            });
      });
}
