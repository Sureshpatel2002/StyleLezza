import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/element/custom_textfield.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';

import '../../utils/utils.dart';
import '../../view_model/auth_view_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(ResponsivePadding.getPagePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderColor)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/arrow_left.svg',
                      width: 15,
                      height: 15,
                      color: AppColors.primaryMainColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ResponsivePadding.getWidgetPadding(context) * 3,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    const CustomText(
                      text: 'Forgot Password',
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                      size: 24,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const CustomText(
                      text: 'Please enter the email',
                      color: AppColors.textSubH1Color,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      size: 14,
                    ),
                    SizedBox(
                      height: ResponsivePadding.getWidgetPadding(context) * 3,
                    ),
                    CustomTextField(
                      controller:
                          Provider.of<AuthViewModel>(context).emailController,
                      borderColor: AppColors.borderColor,
                      isEnabled: true,
                      keyBoardType: TextInputType.emailAddress,
                      labelText: 'Email Address',
                    ),
                    SizedBox(
                      height: ResponsivePadding.getWidgetPadding(context) * 3,
                    ),
                    Consumer<AuthViewModel>(builder: (context, model, child) {
                      return CustomButton(
                        onTap: () {
                          if (model.emailController.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                                "Please enter your email", context);
                          } else {
                            if (model.emailController.text.isNotEmpty) {
                              model.forgotPassword(
                                  model.emailController.text, context);
                            } else {
                              Utils.flushBarErrorMessage(
                                  "Please enter valid email", context);
                            }
                          }
                        },
                        fullsize: true,
                        isEnabled: true,
                        child: model.isLoading
                            ? Utils.spinkitButtons
                            : const CustomText(
                                text: 'Verify',
                                color: AppColors.whiteColor,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400,
                                size: 14,
                              ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
