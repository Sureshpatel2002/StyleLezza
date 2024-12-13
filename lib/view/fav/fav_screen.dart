import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stylelezza/element/custom_item_chip.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view_model/home_view_model.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<HomeViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        title: const CustomText(text: 'Favorites',color: AppColors.textSubH3Color,fontWeight: FontWeight.w700,size: 24,),
      ),
      body: favoriteProvider.favoriteList.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          :Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsivePadding.getPagePadding(context),vertical: ResponsivePadding.getPagePadding(context)),
                      child: Wrap(
                        spacing: ResponsivePadding.getWidgetPadding(context),
                        runSpacing: ResponsivePadding.getWidgetPadding(context),
                        children: List.generate(
                            favoriteProvider.favoriteList.length, (index) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width -
                                    (ResponsivePadding.getPagePadding(context) *
                                        3)) /
                                2,
                            child: CustomItemCard(
                              onFavoriteTap:  () {
                             favoriteProvider.toggleFavorite(favoriteProvider.favoriteList[index]);
                            },
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RoutesName.productDetailScreen,
                                    arguments:
                                        favoriteProvider.favoriteList[index]);
                              },
                              labelText: favoriteProvider.favoriteList[index].name!,
                              imagePath:
                                  favoriteProvider.favoriteList[index].images!.first,
                              price: favoriteProvider.favoriteList[index].price
                                  .toString(),
                              rating: favoriteProvider.favoriteList[index].rating
                                  .toString(), isFavorite: favoriteProvider.favoriteList.any((item) => item.id == favoriteProvider.favoriteList[index].id),
                            ),
                          );
                        }),
                      )),
    );
  }
}
