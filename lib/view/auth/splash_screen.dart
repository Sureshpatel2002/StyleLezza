import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view_model/auth_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggedIn(context);
    });
  }

  Future<void> loggedIn(BuildContext context) async {
    if (user != null) {
      var userData = await AuthViewModel().getUserDataFromFirestore(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Navigator.pushReplacementNamed(context, RoutesName.adminScreen);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.bottombar);
      }
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Style',
              style: GoogleFonts.publicSans(
                color: AppColors.primaryMainColor,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: 'Lezza',
              style: GoogleFonts.publicSans(
                color: AppColors.textSubH3Color,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
