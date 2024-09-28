import 'package:card_swiper/card_swiper.dart';
import 'package:digmap/routes/app-route-names.dart';
import 'package:digmap/widget/buttons.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Map<String, dynamic>> _onboardingItems = [
    {
      "image": "assets/images/onboarding1.png",
      "description":
          "FuelAlert is designed to provide most accurate fuel pricing information",
    },
    {
      "image": "assets/images/onboarding2.png",
      "description":
          "Your smart companion for saving on fuel with the best experience",
    },
    {
      "image": "assets/images/onboarding3.png",
      "description":
          "Submit fuel prices and earn points as cash prizes on the go",
    },
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 7,
                  child: Swiper(
                    loop: false,
                    autoplay: true,
                    itemCount: _onboardingItems.length,
                    onIndexChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    itemBuilder: (context, index) => Image.asset(
                      _onboardingItems[index]["image"],
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, right: 20, left: 20),
                    child: Column(
                      children: [
                        (_currentIndex == 0)
                            ? RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                    text: "Find the ",
                                    style: TextStyle(
                                        fontFamily: "PoppinsBold",
                                        fontSize: 27,
                                        color: Color(0xff444444)),
                                    children: [
                                      TextSpan(
                                          text: "cheapest fuel stations ",
                                          style: TextStyle(
                                              fontFamily: "PoppinsBold",
                                              fontSize: 27,
                                              color: Color(0xff009933))),
                                      TextSpan(
                                          text: "nearby",
                                          style: TextStyle(
                                              fontFamily: "PoppinsBold",
                                              fontSize: 27,
                                              color: Color(0xff444444))),
                                    ]),
                              )
                            : (_currentIndex == 1)
                                ? RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                        text: "Up-to-date ",
                                        style: TextStyle(
                                            fontFamily: "PoppinsBold",
                                            fontSize: 27,
                                            color: Color(0xff444444)),
                                        children: [
                                          TextSpan(
                                              text: "fuel prices ",
                                              style: TextStyle(
                                                  fontFamily: "PoppinsBold",
                                                  fontSize: 27,
                                                  color: Color(0xff009933))),
                                          TextSpan(
                                              text: "at your disposal",
                                              style: TextStyle(
                                                  fontFamily: "PoppinsBold",
                                                  fontSize: 27,
                                                  color: Color(0xff444444))),
                                        ]),
                                  )
                                : RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                        text: "Earn points as rewards for ",
                                        style: TextStyle(
                                            fontFamily: "PoppinsBold",
                                            fontSize: 27,
                                            color: Color(0xff444444)),
                                        children: [
                                          TextSpan(
                                              text: "cash prizes ",
                                              style: TextStyle(
                                                  fontFamily: "PoppinsBold",
                                                  fontSize: 27,
                                                  color: Color(0xff009933))),
                                        ]),
                                  ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(_onboardingItems[_currentIndex]["description"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "PoppinsMeds",
                                fontSize: 16,
                                color: Color(0xff444444))),
                        const SizedBox(
                          height: 40,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: _currentIndex,
                          count: _onboardingItems.length,
                          effect: const ExpandingDotsEffect(
                              spacing: 8.0,
                              radius: 10.0,
                              dotWidth: 9.0,
                              dotHeight: 9.0,
                              expansionFactor: 4,
                              dotColor: Color(0xffD9D9D9),
                              activeDotColor: Color(0xff009933)),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Buttons().defaultButtons(
                          isLoading: false,
                          title: "Get Started",
                          action: () {
                            Get.toNamed(signUpScreen);
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
