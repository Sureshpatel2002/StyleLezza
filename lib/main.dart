import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/firebase_options.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/utils/routes/routes.dart';
import 'package:stylelezza/view_model/auth_view_model.dart';
import 'package:stylelezza/view_model/cart_view_model.dart';
import 'package:stylelezza/view_model/home_view_model.dart';
import 'package:stylelezza/view_model/admin_view_model.dart';

/// Ensures all initialization completes before the app runs.
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding before Firebase initialization.
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
   
   Hive.registerAdapter(ProductModelAdapter());
   Hive.registerAdapter(OrderModelAdapter());

   await Hive.openBox<OrderModel>('orders');
 
  runApp(const MainApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider<AdminViewModel>(
          create: (_) => AdminViewModel(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider<CartViewModel>(
          create: (_) => CartViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: AppColors.backgroundColor,
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.system,
        title: 'StyleLezza',
        theme: ThemeData(
          primaryColor: AppColors.primaryMainColor,
          primarySwatch: Colors.blue,
        ),
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
