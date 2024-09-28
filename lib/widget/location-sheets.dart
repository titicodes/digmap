import 'package:digmap/routes/app-route-names.dart';
import 'package:digmap/widget/buttons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class LocationWarningSheet {
  show(context, {title, subtitle, action, buttonName}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              content:  Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontFamily: "PoppinsBold",
                              fontSize: 22,
                              color: Color(0xff575757)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: "PoppinsMeds",
                              fontSize: 14.28,
                              color: Color(0xff808080)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Buttons()
                                  .borderButtons(title: buttonName, action: action),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Buttons().defaultButtons(
                                  isLoading: false,
                                  title: "Restart",
                                  action: () {
                                    Get.offAllNamed(splashScreen);
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ));
  }
}
