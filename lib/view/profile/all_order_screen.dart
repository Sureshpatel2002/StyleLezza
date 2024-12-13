import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/utils/app_colors.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24,
              color: AppColors.whiteColor,
            )),
          title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
          bottom: const TabBar(
             indicatorColor: Colors.blue, // Color of the indicator (the line beneath the tab)
  labelColor: Colors.white,    // Color of the selected tab text
  unselectedLabelColor: Colors.grey, // Color of the unselected tab text
            tabs: [
              Tab(text: 'Success',),
              
              Tab(text: 'Failed'),
            ],
          ),
          backgroundColor: AppColors.textSubH3Color,
        ),
        body: TabBarView(
          children: [
            _buildOrderList('success'),
            _buildOrderList('failed'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid) // Fetch only orders for the current user
          .collection('user_orders')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Orders Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = OrderModel.fromJson(orders[index].data() as Map<String, dynamic>);
            final totalPrice = orderData.totalPrice ?? 0.0;
          final productList = orderData.products ?? [];



            final orderDate = orderData.timeStamp;
            

            return Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(totalPrice, orderDate, orderData.status!),
                    const Divider(color: Colors.grey),
                    _buildProductList(productList),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderHeader(double totalPrice, DateTime? date, String status) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Total: ₹${totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        Text(
          'Date: $date',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status: ${status[0].toUpperCase()}${status.substring(1)}',
              style: TextStyle(
                fontSize: 14,
                color: status == 'success' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              status == 'success'
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: status == 'success' ? Colors.green : Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    log('length:  ${products.length.toString()}');  // Log the number of products

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Products:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        if (products.isEmpty)
          const Text('No products available', style: TextStyle(fontSize: 14, color: Colors.grey))
        else
          Column(
            children: products.map((product) {
              log('Product ID: ${product.id}');  // Log the product ID for debugging

              final productName = product.name ?? 'Unknown Product';
              final productPrice = product.price ?? 0.0;
              final productQuantity = product.quantity ?? 1;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${productPrice.toStringAsFixed(2)} x $productQuantity',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
