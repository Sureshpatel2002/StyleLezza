import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/element/custom_textfield.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';

class CustomHomeAppBar extends StatefulWidget {
  final TextEditingController homeSearchController;

  const CustomHomeAppBar({
    super.key,
    required this.homeSearchController,
  });

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: AppColors.backgroundColor,
            title: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 24,
                  color: AppColors.textSubH3Color,
                ),
                const SizedBox(width: 8.0),
                const CustomText(
                  text: 'India',
                  color: AppColors.primaryMainColor,
                  fontWeight: FontWeight.w500,
                  size: 16,
                ),
                
              ],
            ),
            actions: [
              Container(
                width: 45,
                height: 45,
                margin: EdgeInsets.only(
                    right: ResponsivePadding.getPagePadding(context)),
                decoration: BoxDecoration(
                  color: AppColors.borderColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 24,
                        color: AppColors.primaryMainColor,
                      ),
                      Positioned(
                        top: 0,
                        left: 11,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.getPagePadding(context)),
            child: CustomTextField(
              controller: widget.homeSearchController,
              borderColor: AppColors.borderColor,
              hintText: 'Search...',
              prefixWidget: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/search_icon.svg',
                    color: AppColors.textSubH3Color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
