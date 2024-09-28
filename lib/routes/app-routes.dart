import 'package:digmap/module/authentication/forgot-password/forgot-password-screen.dart';
import 'package:digmap/module/authentication/forgot-password/reset-password-screen.dart';
import 'package:digmap/module/authentication/forgot-password/verify-password-screen.dart';
import 'package:digmap/module/authentication/sign-in/sign-in-screen.dart';
import 'package:digmap/module/authentication/sign-up/sign-up-screen.dart';
import 'package:digmap/module/authentication/sign-up/verify-email-screen.dart';
import 'package:digmap/module/dashboard/dashboard_view.dart';
import 'package:digmap/module/map/main_map_view.dart';
import 'package:digmap/module/onboarding/onboarding-screen.dart';
import 'package:digmap/module/splash/splash.dart';
import 'package:digmap/routes/app-route-names.dart';
import 'package:get/route_manager.dart';

// ================ APP ROUTES ===============

List<GetPage> getPages = [
  GetPage(
      name: splashScreen,
      transition: Transition.cupertino,
      page: () => const SplashScreen()),

  GetPage(
      name: onboardingScreen,
      transition: Transition.cupertino,
      page: () => const OnboardingScreen()),

  GetPage(
      name: signInScreen,
      transition: Transition.cupertino,
      page: () => SignInScreen()),
  GetPage(
      name: signUpScreen,
      transition: Transition.cupertino,
      page: () => SignUpScreen()),
  GetPage(
      name: verifyEmailScreen,
      transition: Transition.cupertino,
      page: () => const VerifyEmailScreen()),
  GetPage(
      name: forgotPasswordScreen,
      transition: Transition.cupertino,
      page: () => ForgotPasswordScreen()),
  GetPage(
      name: resetPasswordScreen,
      transition: Transition.cupertino,
      page: () => ResetPasswordScreen()),
  GetPage(
      name: verifyPasswordScreen,
      transition: Transition.cupertino,
      page: () => const PasswordVerifyEmailScreen()),

  GetPage(
      name: dashboard,
      transition: Transition.cupertino,
      page: () => const DashboardView()),

  GetPage(
      name: mainMapView,
      transition: Transition.cupertino,
      page: () => const MainMapView()),

  // GetPage(
  //   name: profileView,
  //   transition: Transition.cupertino,
  //   page: ()=> ProfileView()
  // ),
  // GetPage(
  //   name: notificationView,
  //   transition: Transition.cupertino,
  //   page: ()=> NotificationView()
  // ),
  // GetPage(
  //   name: changePasswordView,
  //   transition: Transition.cupertino,
  //   page: ()=> ChangePasswordView()
  // ),
  // GetPage(
  //   name: changeLocationView,
  //   transition: Transition.cupertino,
  //   page: ()=> ChangeLocationScreen()
  // ),
  // GetPage(
  //   name: notificationView,
  //   transition: Transition.cupertino,
  //   page: ()=> NotificationView()
  // ),
  // GetPage(
  //   name: myPointsView,
  //   transition: Transition.cupertino,
  //   page: ()=> MyPointsView()
  // ),
  // GetPage(
  //   name: myRewardsView,
  //   transition: Transition.cupertino,
  //   page: ()=> MyRewardsView()
  // ),
  // GetPage(
  //   name: myReviewView,
  //   transition: Transition.cupertino,
  //   page: ()=> MyReviewsView()
  // ),
  // GetPage(
  //   name: changePasswordView,
  //   transition: Transition.cupertino,
  //   page: ()=> ChangePasswordView()
  // ),

  // GetPage(
  //   name: topContributorsScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> TopContributorsScreen()
  // ),
  // GetPage(
  //   name: rulesScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> RulesView()
  // ),

  // GetPage(
  //   name: stationDetailsScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> StationDetailsView()
  // ),
  // GetPage(
  //   name: pumpScaleScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> PumpScaleScreen()
  // ),
  // GetPage(
  //   name: submitPriceScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> SubmitPriceScreen()
  // ),
  // GetPage(
  //   name: queueReportScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> QueueReportScreen()
  // ),
  // GetPage(
  //   name: ratingAndReviewScreen,
  //   transition: Transition.cupertino,
  //   page: ()=> RatingReviewScreen()
  // ),
];
