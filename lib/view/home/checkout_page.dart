import 'package:flutter/material.dart';
import 'package:stylelezza/element/custom_buttom.dart';

import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/element/custom_textfield.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase User
import 'package:country_picker/country_picker.dart'; // For country picker

class CheckoutPage extends StatefulWidget {
  final OrderModel products;

  const CheckoutPage({Key? key, required this.products}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Fetch user info when the page loads
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.0,
              right: 16.0,
              top: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Shipping Information',
                  size: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSubH3Color,
                ),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'Email Address', Icons.email),
                const SizedBox(height: 10),
                _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                const SizedBox(height: 10),
                _buildTextField(_addressLine1Controller, 'Address Line 1'),
                const SizedBox(height: 10),
                _buildTextField(_addressLine2Controller, 'Address Line 2'),
                const SizedBox(height: 10),
                _buildTextField(_cityController, 'City'),
                const SizedBox(height: 10),
                _buildTextField(_stateController, 'State'),
                const SizedBox(height: 10),
                _buildTextField(_pincodeController, 'Pincode'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false, // This hides the country code
                      onSelect: (country) {
                        setState(() {
                          _countryController.text = country
                              .name; // Set selected country to the text field
                        });
                      },
                    );
                  },
                  child: _buildTextField(
                    _countryController,
                    'Country',
                    Icons.location_on,
                    TextInputType
                        .none, // Disable keyboard as we're selecting from the dropdown
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  fullsize: true,
                  onTap: () {
                    Navigator.pop(context);

                    // Update the OrderModel with shipping information
                    OrderModel updatedOrder = widget.products.copyWith(
                      phoneNumber: _phoneController.text,
                      emailAddress: _emailController.text,
                      addressLine1: _addressLine1Controller.text,
                      addressLine2: _addressLine2Controller.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      pincode: _pincodeController.text,
                      country: _countryController.text,
                       
                    );

                    // Pass the updated OrderModel to the payment page
                    Navigator.pushNamed(
                      context,
                      RoutesName.paymentPage,
                      arguments: updatedOrder,
                    );
                  },
                  child: const CustomText(
                    text: 'Proceed to Payment',
                    size: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [IconData? icon, TextInputType keyboardType = TextInputType.text]) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      prefixWidget:
          icon != null ? Icon(icon, color: AppColors.textPrimaryColor) : null,
      keyBoardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.buttonColor),
        ),
        title: const CustomText(
          text: 'Checkout',
          size: 24,
          color: AppColors.textSubH3Color,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Order Summary',
              size: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.products?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = widget.products.products?[index];
                  return Card(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product?.images?.first ??
                              'https://via.placeholder.com/150',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: CustomText(
                        text: product?.name ?? '',
                        size: 16,
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxline: 2,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Size: ${product?.selectedSize}",
                            size: 14,
                            color: AppColors.greyTransparent500,
                          ),
                          CustomText(
                            text: "Price: ₹${product?.price}",
                            size: 14,
                            color: AppColors.greyTransparent500,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Total: ₹${widget.products.totalPrice}',
              size: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSubH2Color,
            ),
            CustomButton(
              fullsize: false,
              onTap: () {
                showBottomSheet(context);
              },
              child: const CustomText(
                text: 'Checkout',
                size: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
