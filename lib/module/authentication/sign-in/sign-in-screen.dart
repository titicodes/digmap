import 'package:digmap/module/auth/contoller/auth_controller.dart';
import 'package:digmap/routes/app-route-names.dart';
import 'package:digmap/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authStateController =
      Get.put(AuthController());

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
            "Sign In",
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
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email Address",
                          style: TextStyle(
                              color: Color(0xff808080),
                              fontSize: 16,
                              fontFamily: "PoppinsMeds"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            controller.updateEmail(value);
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: ValidationBuilder().email().build(),
                          decoration: InputDecoration(
                            hintText: "Enter email address",
                            hintStyle: const TextStyle(
                                color: Color(0xffCCCCCC), fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xffD6D6D6), width: 0.76),
                                borderRadius: BorderRadius.circular(6.1)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff009933), width: 0.76)),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFF0000), width: 0.76)),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFF0000), width: 0.76)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(
                              color: Color(0xff808080),
                              fontSize: 16,
                              fontFamily: "PoppinsMeds"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            controller.updatePassword(value);
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !controller.showPassword,
                          validator: ValidationBuilder().build(),
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.toggleShowPassword();
                              },
                              child: Icon(
                                controller.showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xffCCCCCC),
                              ),
                            ),
                            hintText: "Enter password",
                            hintStyle: const TextStyle(
                                color: Color(0xffCCCCCC), fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xffD6D6D6), width: 0.76),
                                borderRadius: BorderRadius.circular(6.1)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff009933), width: 0.76)),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFF0000), width: 0.76)),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFF0000), width: 0.76)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Checkbox(
                            value: controller.isRemembered,
                            onChanged: (value) {
                              controller.toggleIsRemembered();
                            },
                            activeColor: const Color(0xff009933),
                            side: const BorderSide(color: Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.2)),
                          ),
                          const Text(
                            "Stay logged in",
                            style: TextStyle(
                                color: Color(0xff757575),
                                fontFamily: "PoppinsMeds",
                                fontSize: 14),
                          )
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          Get.toNamed(forgotPasswordScreen);
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color(0xff009933),
                              fontFamily: "PoppinsMeds",
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Buttons().defaultButtons(
                      isLoading: controller.isLoading,
                      title: "Sign In",
                      action: () {
                        (_formKey.currentState!.validate())
                            ? controller.login(controller.email, controller.password)
                            : AutovalidateMode.disabled;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "or sign in with",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff737373),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.signInWithGoogle();
                        },
                        child: SvgPicture.asset(
                          "assets/images/Google.svg",
                          width: 35,
                          height: 38,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SvgPicture.asset(
                        "assets/images/Facebook.svg",
                        width: 55,
                        height: 60,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SvgPicture.asset(
                        "assets/images/Apple.svg",
                        width: 35,
                        height: 38,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Don’t have an account yet? ",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Color(0xff737373)),
                        children: [
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(signUpScreen);
                                },
                                child: const Text("Sign up",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xff009933),
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        color: Color(0xff009933))),
                              )),
                        ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: const BoxDecoration(
              color: Color(0xffFBFBFB),
              border: Border(top: BorderSide(color: Color(0xffD6D6D6)))),
          child: RichText(
            text: const TextSpan(
                text: "By clicking Create Account you agree to the ",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.38,
                    color: Color(0xff737373)),
                children: [
                  TextSpan(
                      text: "Terms ",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.38,
                          color: Color(0xff009933))),
                  TextSpan(
                      text: "and ",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.38,
                          color: Color(0xff737373))),
                  TextSpan(
                      text: "Privacy Policies",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.38,
                          color: Color(0xff009933))),
                ]),
          ),
        ),
      );
    });
  }
}
