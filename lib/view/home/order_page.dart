import 'package:flutter/material.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';

class OrderPage extends StatelessWidget {
  final OrderModel orderData;

  const OrderPage({required this.orderData});

  @override
  Widget build(BuildContext context) {
    // Get the list of products directly from orderData
    final List<ProductModel> productList = orderData.products ?? [];
    final bool isSuccess = orderData.status == 'success';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const CustomText(
          text: 'Order Confirmation',
          size: 24,
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 100,
              ),
            ),
            Center(
              child: Text(
                isSuccess ? 'Order Successful!' : 'Order Failed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image: NetworkImage(product.images?.first ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        product.name ?? 'Product Name',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Size: ${product.selectedSize ?? "N/A"} | Color: ${product.selectedColor ?? "N/A"}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Text(
                        'x${product.quantity ?? 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total Price: ₹${orderData.totalPrice!.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomButton(
              fullsize: true,
              onTap: () {
                Navigator.popAndPushNamed(context, RoutesName.bottombar);
              },
              child: const CustomText(
                text: 'Back to Home',
                size: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              color: AppColors.primaryMainColor,
            ),
          ],
        ),
      ),
    );
  }

  
}
