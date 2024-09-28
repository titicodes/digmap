import 'dart:async';

import 'package:digmap/module/auth/contoller/auth_controller.dart';
import 'package:digmap/routes/app-route-names.dart';
import 'package:digmap/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';

class PasswordVerifyEmailScreen extends StatefulWidget {
  const PasswordVerifyEmailScreen({super.key});

  @override
  State<PasswordVerifyEmailScreen> createState() =>
      _PasswordVerifyEmailScreenState();
}

class _PasswordVerifyEmailScreenState extends State<PasswordVerifyEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Timer _timer;
  int _counter = 60;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          // Trigger your resend email function here
          _isCompleted = true;
          // Reset the counter to 60 seconds
          _counter = 60;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Iconsax.arrow_left,
              )),
          centerTitle: true,
          title: const Text(
            "Verification",
            style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 28,
                color: Color(0xff333333)),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: const Color(0xffFBFBFB),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Enter the code sent to your email ",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Color(0xff8C8C8C)),
                        children: [
                          TextSpan(
                              text:
                                  "${controller.formatEmail(controller.email)} ",
                              style: const TextStyle(
                                  fontFamily: "PoppinsMeds",
                                  fontSize: 14,
                                  color: Color(0xff8C8C8C))),
                          const TextSpan(
                              text: "to reset your password",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: Color(0xff8C8C8C))),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.center,
                    onChanged: (value) {
                      controller.updateCode(value);
                    },
                    validator: ValidationBuilder().build(),
                    length: 4,
                    defaultPinTheme: PinTheme(
                        height: 64,
                        width: 66,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffE2E6E9),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    focusedPinTheme: PinTheme(
                        height: 64,
                        width: 66,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff009933),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    errorPinTheme: PinTheme(
                        height: 64,
                        width: 66,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffFF0000),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  (_isCompleted)
                      ? Center(
                          child: InkWell(
                            onTap: () {
                              controller.resendEmailVerification();
                              setState(() {
                                _isCompleted = false;
                                _counter = 60;
                              });
                            },
                            child: const Text(
                              "Resend Code",
                              style: TextStyle(
                                  color: Color(0xff009933),
                                  fontSize: 16,
                                  fontFamily: "PoppinsMeds"),
                            ),
                          ),
                        )
                      : Text(
                          "Resend code in $_counter seconds",
                          style: const TextStyle(
                              color: Color(0xff009933), fontSize: 16),
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  Buttons().defaultButtons(
                      isLoading: controller.isLoading,
                      title: "Verify",
                      action: () {
                        (_formKey.currentState!.validate())
                            ? Get.toNamed(resetPasswordScreen)
                            : AutovalidateMode.disabled;
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
