import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/utils/app_colors.dart';

class CustomItemCard extends StatefulWidget {
  final String imagePath;
  final String labelText;

  final String price;
  final String rating;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  const CustomItemCard({
    super.key,
    required this.imagePath,
    required this.labelText,
    required this.price,
    required this.rating,
    required this.onTap,  this.onFavoriteTap, required this.isFavorite,
  });

  @override
  State<CustomItemCard> createState() => _CustomItemCardState();
}

class _CustomItemCardState extends State<CustomItemCard> {
  
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))),
          child: GestureDetector(
            onTap: widget.onTap,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                        child: Container(
                          height: 120,
                          color: AppColors.whiteColor,
                          child: Center(
                            child: Image.network(widget.imagePath,
                                fit: BoxFit.fitHeight,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 120,
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
                                errorBuilder: (context, error, stackTrace) =>
                                    SizedBox(
                                      width: double.infinity,
                                      height: 120,
                                      child: Shimmer.fromColors(
                                        baseColor: AppColors.greyTransparent300,
                                        highlightColor: Colors.white,
                                        period: const Duration(milliseconds: 2000),
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: widget.onFavoriteTap,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.whiteColor.withOpacity(0.2)),
                              child:  Center(
                                child: Icon(
                                  widget.isFavorite ? Icons.favorite :  Icons.favorite_border,
                                  size: 24,
                                  
                                  
                                  color:widget.isFavorite ? AppColors.redColor : AppColors.buttonColor,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Container(
                    color: AppColors.buttonColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          CustomText(
                            text: widget.labelText,
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryMainColor,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text: widget.rating.toString(),
                                    size: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimaryColor,
                                  ),
                                ],
                              ),
                              CustomText(
                                text: widget.price.toString(),
                                size: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryMainColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
