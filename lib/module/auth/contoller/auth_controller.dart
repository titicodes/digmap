import 'package:digmap/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final AuthServices _authServices = AuthServices();
  
  // Reactive user variable
  Rx<User?> user = Rx<User?>(null);
   // INSTANT VARIABLES
  String _email = "";
  String _password = "";
  String _phone = "";
  String _passwordConfirm = "";
  String _currentPassword = "";
  String _code = "";
  bool _showPassword = false;
  bool _isLoading = false;
  bool _isRemembered = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isResendingEmail = false.obs;

  // GETTERS
  String get email => _email;
  String get password => _password;
  String get phone => _phone;
  String get passwordConfirm => _passwordConfirm;
  String get currentPassword => _currentPassword;
  String get code => _code;
  bool get isLoading => _isLoading;
  bool get showPassword => _showPassword;
  bool get isRemembered => _isRemembered;

  // SETTERS
  updateEmail(value) {
    _email = value;
    update();
  }

  updatePassword(value) {
    _password = value;
    update();
  }

  updatePhone(value) {
    _phone = value;
    update();
  }

  updatePasswordConfirm(value) {
    _passwordConfirm = value;
    update();
  }

  updateCurrentPassword(value) {
    _currentPassword = value;
    update();
  }

  updateCode(value) {
    _code = value;
    update();
  }

  toggleShowPassword() {
    _showPassword = !_showPassword;
    update();
  }

  toggleIsRemembered() {
    _isRemembered = !_isRemembered;
    update();
  }

  updateIsLoading(value) {
    _isLoading = value;
    update();
  }

  // FORMAT EMAIL
  String formatEmail(String email) {
    // Split the email into two parts: username and domain
    List<String> parts = email.split("@");

    // Check if the email has exactly two parts
    if (parts.length != 2) {
      // Invalid email format, return the original email
      return email;
    }

    String username = parts[0];
    String domain = parts[1];

    // Ensure at least 4 characters of the username are visible
    int visibleLength = 4;
    if (username.length <= visibleLength) {
      // If the username is shorter than or equal to the visible length, show it as is
      return email;
    }

    // Replace characters in the username except the first few with asterisks
    String obscuredUsername = username.substring(0, visibleLength) +
        '*' * (username.length - visibleLength);

    // Combine the obscured username and domain to form the final email
    String formattedEmail = "$obscuredUsername@$domain";

    return formattedEmail;
  }

  @override
  void onReady() {
    super.onReady();
    // Bind user stream to automatically track authentication state
    user.bindStream(_authServices.firebaseAuth.authStateChanges());
    ever(user, _initialScreen);
  }

  // Navigate based on authentication state
  _initialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed('/login'); // Redirect to login screen if not authenticated
    } else {
      Get.offAllNamed('/home');  // Redirect to home if authenticated
    }
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    try {
      User? loggedInUser = await _authServices.loginService(email, password);
      if (loggedInUser != null) {
        Get.snackbar(
          "Login Successful",
          "Welcome ${loggedInUser.email}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      User? googleUser = await _authServices.googleAuthLoginService();
      if (googleUser != null) {
        Get.snackbar(
          "Login Successful",
          "Welcome ${googleUser.displayName}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Google Sign-In Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Register new user
  Future<void> register() async {
    try {
      User? newUser = await _authServices.registerService();
      if (newUser != null) {
        await _authServices.verifyEmailCodeService();
        Get.snackbar(
          "Registration Successful",
          "A verification email has been sent to ${newUser.email}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Registration Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Send password reset email
  Future<void> forgotPassword(String email) async {
    try {
      await _authServices.forgotPasswordService(email);
      Get.snackbar(
        "Password Reset",
        "A password reset email has been sent to $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to verify email and navigate to the login screen
  Future<void> verify() async {
    _isLoading = true;
    try {
      User? user = _auth.currentUser;
      await user?.reload();  // Reload to get the latest user info

      if (user != null && user.emailVerified) {
        Get.snackbar(
          "Verified",
          "Your email is verified!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor,
        );
        Get.offAllNamed("/login");  // Navigate to login after verification
      } else {
        Get.snackbar(
          "Not Verified",
          "Your email is not verified yet. Please check your inbox.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to verify email: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    } finally {
      _isLoading = false;
    }
  }

  // Function to resend email verification
  Future<void> resendEmailVerification() async {
    _isLoading = true;
    try {
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          "Verification Email Sent",
          "A verification email has been sent to ${user.email}. Please check your inbox.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor,
        );
      } else {
        Get.snackbar(
          "Error",
          "Unable to send verification email. Make sure you're logged in and the email is not verified already.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send verification email: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    } finally {
      _isLoading = false;
    }
  }

  // Email formatting
  // String formatEmail(String email) {
  //   int index = email.indexOf('@');
  //   return email.replaceRange(1, index, "*" * (index - 1));
  // }

  Future<void> resetPassword() async {
    _isLoading = true;
    try {
      // Here, 'oobCode' should be obtained from the password reset email sent to the user
      String oobCode = ""; // Replace this with the actual reset code
      await _auth.confirmPasswordReset(code: oobCode, newPassword: password);
      
      Get.snackbar(
        "Success",
        "Password has been reset successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
      Get.offAllNamed("/login");  // Navigate to the login screen after reset
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reset password: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    } finally {
      _isLoading = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authServices.logoutService();
      Get.snackbar(
        "Logged Out",
        "You have been logged out successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Logout Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
