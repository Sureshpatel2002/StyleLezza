import 'package:flutter/material.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/testing.dart';

import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view/admin/admin_home_page.dart';
import 'package:stylelezza/view/auth/forgot_password_screen.dart';
import 'package:stylelezza/view/auth/login_screen.dart';
import 'package:stylelezza/view/auth/splash_screen.dart';
import 'package:stylelezza/view/bottombar/bottombar.dart';
import 'package:stylelezza/view/cart/cart_screen.dart';
import 'package:stylelezza/view/bot/chat_screen.dart';
import 'package:stylelezza/view/fav/fav_screen.dart';
import 'package:stylelezza/view/home/checkout_page.dart';
import 'package:stylelezza/view/home/home_screen.dart';
import 'package:stylelezza/view/home/order_page.dart';
import 'package:stylelezza/view/home/payment_page.dart';
import 'package:stylelezza/view/home/product_detail_screen.dart';
import 'package:stylelezza/view/profile/all_order_screen.dart';
import 'package:stylelezza/view/profile/profile_screen.dart';

import '../../view/admin/screens/edit_product_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.adminScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => AdminHomePage());

      case RoutesName.homeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgotPasswordScreen());
      case RoutesName.productDetailScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailScreen(
                  product: settings.arguments as ProductModel,
                ));
      case RoutesName.cartScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CartScreen());
      case RoutesName.profileScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      case RoutesName.favScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FavScreen());
      case RoutesName.bottombar:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Bottombar());
      case RoutesName.editProductScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => EditProductScreen(
                  product: settings.arguments as ProductModel,
                ));
      case RoutesName.orderPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => OrderPage(
                  orderData: settings.arguments as OrderModel,
                ));
      case RoutesName.paymentPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => PaymentPage(
                  product: settings.arguments as OrderModel,
                ));
      case RoutesName.checkoutPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => CheckoutPage(
                  products: settings.arguments as OrderModel,
                ));
      case RoutesName.orderSummary:
        return MaterialPageRoute(
            builder: (BuildContext context) => OrderSummary());
      case RoutesName.testingScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => TestingScreen());
      case RoutesName.chatScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
