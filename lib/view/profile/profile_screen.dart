import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view_model/auth_view_model.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? uid;
  String? email;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthViewModel().getUserDataFromSharedPrefs();
    if (userData != null) {
      setState(() {
        uid = userData['uid'];
        email = userData['email'];
        username = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.getPagePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              const Divider(color: AppColors.borderColor),
              const SizedBox(height: 20),
              _buildOptionsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.textSubH2Color.withOpacity(0.1),
          child: const Icon(Icons.person, size: 50, color: AppColors.textPrimaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: username ?? 'User Name',
                size: 20,
          
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: email ?? 'user@example.com',
                size: 16,
                maxline: 2,
                
                textOverflow: TextOverflow.ellipsis,
                color: AppColors.greyTransparent500,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Column(
      children: [
        // _buildOptionTile(Icons.payment, 'Payment Method', onTap: () {
        //   // Navigate to payment method screen
        // }),
        _buildOptionTile(Icons.shopping_bag, 'My Orders', onTap: () {
          Navigator.pushNamed(context, RoutesName.orderSummary);// Navigate to OrderScreen
        }),
        // _buildOptionTile(Icons.settings, 'Settings', onTap: () {
        //   // Navigate to settings screen
        // }),
        _buildOptionTile(Icons.help, 'Help', onTap: () {
          // _openWhatsApp(); // Redirect to WhatsApp
          Navigator.pushNamed(context, RoutesName.chatScreen);
        }),
        _buildOptionTile(Icons.privacy_tip, 'Privacy Policy', onTap: () {
          // Navigate to privacy policy
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => InAppWebViewScreen(url: 'https://www.termsfeed.com/live/8362d846-0da1-479e-bf6c-44a9def32ba6',text: 'Privacy Policy',),
          ),);
        }),
        _buildOptionTile(Icons.logout, 'Logout',
            onTap: () => AuthViewModel().signOut(context)),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimaryColor),
      title: CustomText(
        text: title,
        size: 18,
        color: AppColors.textPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 18, color: AppColors.borderColor),
      onTap: onTap,
    );
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '7726930362'; // Phone number
    final url = 'https://wa.me/$phoneNumber?text=Hello, I need help with StyleLezza.';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch WhatsApp');
    }
  }
}



class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String text;
  const InAppWebViewScreen({super.key, required this.url, required this.text});

  @override
  _InAppWebViewScreenState createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  InAppWebViewController? _webViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.textSubH3Color,size: 24,)),
        title: CustomText(text: widget.text,color: AppColors.textSubH3Color,fontWeight: FontWeight.w600,size: 24,),
      ),
      body: Stack(
        children: [
          InAppWebView(
             initialUrlRequest: URLRequest(
              url: WebUri(widget.url),  // Convert the string to WebUri
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          if (progress < 1.0)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

