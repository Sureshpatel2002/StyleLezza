import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylelezza/element/custom_item_chip.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/utils/utils.dart';
import 'package:stylelezza/view/home/home_custom_widget/custom_appbar.dart';
import 'package:stylelezza/view/home/home_custom_widget/custom_image_container.dart';
import 'package:stylelezza/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double minPrice = 0;
  double maxPrice = 10000;
  TextEditingController homeSearchController = TextEditingController();
  List<Map<String, String>> categories = [
    {'name':'All','image':'assets/category-alt.svg'},
    {'name': 'T-shirt', 'image': 'assets/t-shirt.svg'},
    {'name': 'Pant', 'image': 'assets/pant.svg'},
    {'name': 'Jacket', 'image': 'assets/jacket.svg'},
    {'name': 'Kurti', 'image': 'assets/kurti.svg'},
    {'name': 'Lehanga', 'image': 'assets/lehnga.svg'},
    {'name': 'Jeans', 'image': 'assets/jeans.svg'},
    {'name': 'Shirt', 'image': 'assets/shirt.svg'},
  ];

  @override
  void initState() {
    super.initState();
    homeSearchController.addListener(_searchProducts);
     // Delay initialization until after the widget is built
   WidgetsBinding.instance.addPostFrameCallback((_) async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    await homeViewModel.initialize(); // Wait for initialization
  });
  }

  @override
  void dispose() {
    homeSearchController.removeListener(_searchProducts);
    homeSearchController.dispose();
    super.dispose();
  }

  void _searchProducts() {
    String query = homeSearchController.text;
    Provider.of<HomeViewModel>(context, listen: false).searchProducts(query);
  }

  Widget buildImageContainer(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
        ),
      ),
      errorWidget: (context, url, error) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          
        ),
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: CustomHomeAppBar(
                  homeSearchController: homeSearchController,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsivePadding.getPagePadding(context),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 2.0,
                      initialPage: 0,
                    ),
                    items: homeViewModel.carouselImages.map((imageUrl) {
                      return buildImageContainer(imageUrl);
                    }).toList(),
                  ),
                ),
                SizedBox(height: ResponsivePadding.getWidgetPadding(context) * 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsivePadding.getPagePadding(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const CustomText(
                        text: 'Category',
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                        size: 18,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              double tempMinPrice = minPrice;
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    title: const Text("Filter by Price"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Slider(
                                          value: tempMinPrice,
                                          min: 0,
                                          max: maxPrice,
                                          divisions: 100,
                                          label: tempMinPrice.toStringAsFixed(2),
                                          onChanged: (value) {
                                            setState(() {
                                              tempMinPrice = value;
                                            });
                                          },
                                        ),
                                        Text(
                                          "Min Price: ₹${tempMinPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            minPrice = tempMinPrice;
                                          });
                                          homeViewModel.filterProductsByPrice(minPrice);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Apply"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/filter.svg',
                              width: 18,
                              height: 18,
                              color: AppColors.textSubH3Color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsivePadding.getWidgetPadding(context)),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsivePadding.getPagePadding(context),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            String category = categories[index]['name']!.toLowerCase();
                            if(category == 'All'.toLowerCase()){
                                homeViewModel.showAllProducts();
                            }else{
                            homeViewModel.filterProductsByCategory(category);}
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.textSubH3Color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    categories[index]['image']!,
                                    color: AppColors.textSubH3Color,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: categories[index]['name']!,
                                color: AppColors.textPrimaryColor,
                                size: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: ResponsivePadding.getWidgetPadding(context)),
                Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
                  if (homeViewModel.isLoading) {
                    return const Center(child: Utils.spinkitLoading);
                  }
                  if (homeViewModel.filterList.isEmpty) {
                    return const Center(child: Text('No products available'));
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsivePadding.getPagePadding(context)),
                    child: Wrap(
                      spacing: ResponsivePadding.getWidgetPadding(context),
                      runSpacing: ResponsivePadding.getWidgetPadding(context),
                      children: List.generate(homeViewModel.filterList.length, (index) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 
                                  (ResponsivePadding.getPagePadding(context) * 3)) / 2,
                          child: CustomItemCard(
                            onFavoriteTap: () {
                              homeViewModel.toggleFavorite(homeViewModel.filterList[index]);
                            },
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RoutesName.productDetailScreen,
                                  arguments: homeViewModel.filterList[index]);
                            },
                            labelText: homeViewModel.filterList[index].name!,
                            imagePath: homeViewModel.filterList[index].images!.first,
                            price: homeViewModel.filterList[index].price.toString(),
                            rating: homeViewModel.filterList[index].rating.toString(),
                            isFavorite: homeViewModel.favoriteList.any((item) =>
                                item.id == homeViewModel.filterList[index].id),
                          ),
                        );
                      }),
                    ),
                  );
                }),
                SizedBox(height: ResponsivePadding.getWidgetPadding(context)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
