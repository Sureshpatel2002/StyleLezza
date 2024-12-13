import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/element/custom_textfield.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view/profile/profile_screen.dart';
import 'package:stylelezza/view_model/auth_view_model.dart';

import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final bool isNewUser = viewModel.isNewUser;
    
    bool isValidEmail(String email) {
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: EdgeInsets.all(ResponsivePadding.getPagePadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: isNewUser ? 'Create Account' : 'Sign In',
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                  size: 24,
                ),
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context),
              ),
              Center(
                child: CustomText(
                  text: isNewUser
                      ? 'Fill your information below or register\n with your social account.'
                      : 'Hi! Welcome back, you\'ve been missed',
                  color: AppColors.textSubH1Color,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  size: 14,
                ),
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 3,
              ),
              if (isNewUser) ...[
                const CustomText(
                  textAlign: TextAlign.center,
                  text: 'Name',
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                  size: 18,
                ),
                CustomTextField(
                  controller: viewModel.nameController,
                  borderColor: AppColors.borderColor,
                  isEnabled: true,
                  keyBoardType: TextInputType.name,
                  labelText: 'John Doe',
                ),
                SizedBox(
                  height: ResponsivePadding.getWidgetPadding(context),
                ),
              ],
              const CustomText(
                textAlign: TextAlign.center,
                text: 'Email',
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
                size: 18,
              ),
              CustomTextField(
                controller: viewModel.emailController,
                borderColor: AppColors.borderColor,
                isEnabled: true,
                keyBoardType: TextInputType.emailAddress,
                labelText: 'Email Address',
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context),
              ),
              const CustomText(
                textAlign: TextAlign.center,
                text: 'Password',
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
                size: 18,
              ),
              CustomTextField(
                suffixIcon: true,
                borderColor: AppColors.borderColor,
                isObsecure: true,
                controller: viewModel.passwordController,
                isEnabled: true,
                keyBoardType: TextInputType.text,
                labelText: 'Password',
              ),
              const SizedBox(
                height: 8,
              ),
              isNewUser
                  ? Row(
                      children: <Widget>[
                        Consumer<AuthViewModel>(
                      builder: (context, model, child) => Checkbox(
                        value: model.isTermsAccepted,
                        onChanged: (value) {
                          model.toggleTermsAccepted(value);
                        },
                      ),
                    ),
                        const CustomText(
                          text: 'Agree with ',
                          size: 14,
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                         GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  InAppWebViewScreen(url: 'https://www.termsfeed.com/live/6632ea83-e3d5-4a05-8d42-cc7e3381feb0',text: 'Terms & Conditions',);
                            },));
                          },
                           child: CustomText(
                            textDecoration: TextDecoration.underline,
                            textDecorationColor: AppColors.textSubH3Color,
                            text: 'Terms & Condition',
                            size: 14,
                            color: AppColors.textSubH3Color,
                            fontWeight: FontWeight.w400,
                                                   ),
                         ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<AuthViewModel>(
                            builder: (context, model, child) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.forgotPasswordScreen);
                            },
                            child: const CustomText(
                              text: 'Forgot Password',
                              textDecorationColor: AppColors.textSubH3Color,
                              color: AppColors.textSubH3Color,
                              fontWeight: FontWeight.w400,
                              size: 14,
                              textAlign: TextAlign.end,
                              textDecoration: TextDecoration.underline,
                            ),
                          );
                        }),
                      ],
                    ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 2,
              ),
              Consumer<AuthViewModel>(
                builder: (context, model, child) => CustomButton(
                  onTap: model.isLoading
                      ? null
                      : () async {


                          String email = model.emailController.text.trim();
                          String password =
                              model.passwordController.text.trim();
                          print(email);
                          print(password);
                          // Email validation
                          if (!isValidEmail(email)) {
                            Utils.flushBarErrorMessage(
                                "Please enter a valid email address", context);
                            return;
                          } 
                          if (model.isNewUser) {
                            // Sign Up flow
                            if (model.nameController.text.isNotEmpty &&
                                model.emailController.text.isNotEmpty &&
                                model.passwordController.text.isNotEmpty && model.isTermsAccepted) {
                              model.signUp(
                                  email,
                                  password,
                                  model.nameController.text,
                                  // Assuming device token will be added later
                                  context,
                                  '');

                              // Show the Flushbar message before toggling the user state
                              Utils.flushBarErrorMessage(
                                  "Please verify your email and then back to login",
                                  context);

                              await Future.delayed(const Duration(seconds: 2));

                              await model.signOut(context);

                              model.toggleIsNewUser();
                            } else  {
                              Utils.flushBarErrorMessage(
                                  "Please fill all fields", context);
                            }
                          } else {
                            // Sign In flow
                            if (model.emailController.text.isNotEmpty &&
                                model.passwordController.text.isNotEmpty) {
                              UserCredential? userCredential =
                                  await model.signIn(
                                model.emailController.text,
                                model.passwordController.text,
                                context,
                              );
                              var userData =
                                  await model.getUserDataFromFirestore(
                                      userCredential!.user!.uid);
                              if (userCredential.user!.emailVerified) {
                                if (userData[0]['isAdmin'] == true) {
                                  Navigator.pushReplacementNamed(
                                      context, RoutesName.adminScreen);
                                  Utils.flushBarSuccessMessage(
                                      'Welcome Back! , Successfully login',
                                      context);
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, RoutesName.bottombar);
                                  Utils.flushBarSuccessMessage(
                                      'Welcome Back! , Successfully login',
                                      context);
                                }
                              } else {
                                Utils.flushBarErrorMessage(
                                    "Please verify your email and password",
                                    context);
                              }
                            } else {
                              Utils.flushBarErrorMessage(
                                  "Please enter email and password", context);
                            }
                          }
                        },
                  isEnabled: !model.isLoading && model.isSignInEnabled && (isNewUser ? model.isTermsAccepted : true),
                  fullsize: true,
                  child: model.isLoading
                      ? Utils.spinkitButtons
                      : CustomText(
                          text: model.isNewUser ? 'Sign Up' : 'Sign In',
                          size: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                ),
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 3,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.greyTransparent500,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    text: 'Or sign in with',
                    size: 14,
                    color: AppColors.textSubH2Color,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.greyTransparent500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 3,
              ),
              Consumer<AuthViewModel>(
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconWithCenter(
                        onTap: () {
                          value.signInwithGoogle(context);
                        },
                        isSvg: true,
                        svgPath: 'assets/google.svg',
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                       IconWithCenter(
                        onTap: () {
                          value.signInWithGmail(context);
                        },
                        isSvg: true,
                        svgPath: 'assets/gmail.svg',
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 3,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: isNewUser
                        ? "Already have an account "
                        : 'Don\'t have an account? ',
                    size: 14,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: () => viewModel.toggleIsNewUser(),
                    child: CustomText(
                      textDecoration: TextDecoration.underline,
                      textDecorationColor: AppColors.textSubH3Color,
                      text: isNewUser ? 'Sign In' : 'Sign Up',
                      size: 14,
                      color: AppColors.textSubH3Color,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconWithCenter extends StatelessWidget {
  final bool isSvg;
  final String? svgPath;
  final String? imagePath;
  final VoidCallback? onTap;
  const IconWithCenter({
    super.key,
    required this.isSvg,
    this.svgPath,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: isSvg
              ? SvgPicture.asset(
                  svgPath!,
                  width: 24,
                  height: 24,
                )
              : Image.asset(
                  imagePath!,
                  width: 24,
                  height: 24,
                ),
        ),
      ),
    );
  }
}
