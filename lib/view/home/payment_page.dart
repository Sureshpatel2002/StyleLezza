import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view_model/payment_view_model.dart';


class PaymentPage extends StatefulWidget {
  final OrderModel product;

  const PaymentPage({required this.product});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentViewModel(),
      child: Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24,
                color: AppColors.textSubH3Color,
              ),
            ),
            title: const CustomText(
              text: 'Payment',
              size: 24,
              color: AppColors.textSubH3Color,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: AppColors.whiteColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price: ₹${widget.product.totalPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: TextEditingController(),
                  label: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  icon: Icons.credit_card,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: TextEditingController(),
                  label: 'Expiry Date',
                  hintText: 'MM/YY',
                  icon: Icons.date_range,
                  inputType: TextInputType.datetime,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: TextEditingController(),
                  label: 'CVV',
                  hintText: '123',
                  icon: Icons.lock,
                  inputType: TextInputType.number,
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: TextEditingController(),
                  label: 'UPI ID',
                  hintText: 'yourname@upi',
                  icon: Icons.account_balance_wallet,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  fullsize: true,
                  onTap: () {
                   paymentViewModel.showPaymentDialog(context, widget.product); // Call the dialog here
                  },
                  color: AppColors.primaryMainColor,
                  child: const CustomText(
                    text: 'Pay Now',
                    size: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primaryMainColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryMainColor),
        ),
      ),
    );
  }

 


}
