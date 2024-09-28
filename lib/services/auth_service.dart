import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; // Make this public
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? email;
  String? password;

  // LOGIN with email and password
  Future<User?> loginService(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      log("Login error: ${error.message}");
      throw error.message!;
    }
  }

  // GOOGLE SIGN-IN
  Future<User?> googleAuthLoginService() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If the user cancels the Google sign-in process
        log("Google Sign-In aborted by user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      log("Google sign-in error: ${error.message}");
      throw error.message!;
    }
  }

  // REGISTER a new user with email and password
  Future<User?> registerService() async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email?? '',
        password: password?? '',
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      log("Registration error: ${error.message}");
      throw error.message!;
    }
  }

  // VERIFY EMAIL (send verification email)
  Future<void> verifyEmailCodeService() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        log("Verification email sent.");
      } else {
        log("User is null or already verified.");
      }
    } on FirebaseAuthException catch (error) {
      log("Verification email error: ${error.message}");
      throw error.message!;
    }
  }

  // FORGOT PASSWORD (send password reset email)
  Future<void> forgotPasswordService(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      log("Password reset email sent.");
    } on FirebaseAuthException catch (error) {
      log("Forgot password error: ${error.message}");
      throw error.message!;
    }
  }

  // RESET PASSWORD
  Future<void> resetPasswordService(String code, String newPassword) async {
    try {
      await firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      log("Password has been reset.");
    } on FirebaseAuthException catch (error) {
      log("Reset password error: ${error.message}");
      throw error.message!;
    }
  }

  // RESEND EMAIL VERIFICATION
  Future<void> resendEmailService() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        log("Email verification resent.");
      } else {
        log("User is null or already verified.");
      }
    } on FirebaseAuthException catch (error) {
      log("Resend email verification error: ${error.message}");
      throw error.message!;
    }
  }

  // LOGOUT
  Future<void> logoutService() async {
    try {
      await firebaseAuth.signOut();
      log("User logged out.");
    } catch (error) {
      log("Logout error: $error");
      throw error;
    }
  }
}
