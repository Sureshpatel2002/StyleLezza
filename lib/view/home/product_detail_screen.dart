
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/view_model/cart_view_model.dart';
import 'package:stylelezza/view_model/home_view_model.dart';

import '../../utils/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;

  bool get isButtonEnabled => selectedSize != null && selectedColor != null;

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(children: [
              Container(
                color: AppColors.whiteColor,
                child: CarouselSlider(
                    items: widget.product.images!.map((image) {
                      return Image.network(
                        width: double.infinity,
                        image,
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: double.infinity,
                              height: double.maxFinite,
                              child: Shimmer.fromColors(
                                baseColor: AppColors.greyTransparent300,
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 2000),
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) => SizedBox(
                          width: double.infinity,
                          height: double.maxFinite,
                          child: Shimmer.fromColors(
                            baseColor: AppColors.greyTransparent300,
                            highlightColor: Colors.white,
                            period: const Duration(milliseconds: 2000),
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1.5,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 4),
                    )),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.whiteColor.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 24,
                          color: AppColors.buttonColor,
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     HomeViewModel().toggleFavorite(widget.product);
                    //   },
                    //   child: Container(
                    //     width: 50,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(50),
                    //         color: AppColors.whiteColor.withOpacity(0.2)),
                    //     child: const Center(
                    //       child: Icon(
                    //         size: 24,
                    //         Icons.favorite_border,
                    //         color: AppColors.buttonColor,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.all(
                  ResponsivePadding.getPagePadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    text: widget.product.name!,
                    size: 24,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: ResponsivePadding.getWidgetPadding(context) * 2,
                  ),
                  const CustomText(
                      text: 'Product Details',
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                      size: 18),
                  SizedBox(
                    height: ResponsivePadding.getWidgetPadding(context),
                  ),
                  CustomText(
                    text: widget.product.description!,
                    size: 14,
                    color: AppColors.textSubH2Color,
                    fontWeight: FontWeight.w400,
                  ),
                  const Divider(color: AppColors.borderColor),
                  const CustomText(
                      text: 'Select Size',
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                      size: 18),
                  Row(
                    children: widget.product.sizes!.map((size) {
                      bool isSelected = size == selectedSize;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            border: isSelected
                                ? null
                                : Border.all(color: AppColors.borderColor),
                            color: isSelected
                                ? AppColors.buttonColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            text: size,
                            size: 16,
                            color: isSelected
                                ? AppColors.whiteColor
                                : AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const CustomText(
                      text: 'Select Color',
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                      size: 18),
                  Wrap(
                    children: widget.product.colors!.map((color) {
                      bool isSelected = color == selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse(color))),
                          child: isSelected
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.buttonColor,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1),
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.getPagePadding(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CustomText(
                      text: 'Total Price',
                      size: 18,
                      color: AppColors.textSubH2Color,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      text: '₹${widget.product.price}',
                      size: 18,
                      color: AppColors.textSubH2Color,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                CustomButton(
                  onTap: isButtonEnabled
                      ? () async {
                          await CartViewModel().addToCart(
                            widget.product,
                            selectedSize!,
                            selectedColor!,
                            context,
                          );
                        }
                      : null,
                  fullsize: false,
                  color: isButtonEnabled
                      ? AppColors.buttonColor
                      : AppColors.greyTransparent300,
                  borderRadius: 50.0,
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 24,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(width: 8),
                      CustomText(
                        text: 'Add to cart',
                        size: 18,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
