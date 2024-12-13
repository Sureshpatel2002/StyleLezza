import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/utils/utils.dart';

class PaymentViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box _cartBox = Hive.box('cart'); // Assuming cart is stored in Hive

  double calculateTotalPrice(OrderModel product) {
    // Calculate total price for a single product
    return (product.totalPrice ?? 0) * (product.products!.first.quantity!);
  }

 Future<void> saveOrder(OrderModel order, String status) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // Create order data
      final orderData = {
        'userId': user.uid, // Store the user's UID
        'products': order.products != null ? order.products?.map((product) => product.toJson()).toList() : [], // Ensure products is not null
        'totalPrice': order.totalPrice, // Assuming totalPrice is calculated in OrderModel
        'status': status,
        'timestamp': DateTime.now(),
        'userEmail': user.email, // Optionally store user's email
        'userName': user.displayName ?? 'Anonymous', // Optionally store user's name

      };

      print('User ID: ${user.uid}');
      print('Order Data: $orderData');

      // Save the order to Firestore under the user's UID and in a 'user_orders' sub-collection
      await _firestore.collection('orders').doc(user.uid).collection('user_orders').add(orderData);

      print('Order saved successfully');
    } else {
      print('User not logged in');
    }
  } catch (e) {
    print('Error saving order: $e');
  }
}



  Future<void> removeFromCart(BuildContext context) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Clear all products from Hive
        var cartBox = await Hive.openBox('cart');
        await cartBox.clear(); // Clear all products from Hive
        print('All products cleared from Hive');

        // Clear all products from Firestore
        final cartRef = _firestore
            .collection('cart')
            .doc(user.uid)
            .collection('products'); // Reference to the user's products sub-collection

        // Delete all documents in the products sub-collection
        final snapshot = await cartRef.get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete(); // Delete each product document
          print('Product removed from Firestore: ${doc.id}');
        }

        Utils.flushBarSuccessMessage('All products removed from cart!', context);
      } else {
        print('User is not logged in, cannot clear cart');
        Utils.flushBarErrorMessage('User not logged in!', context);
      }
    } catch (e) {
      print('Error removing products from cart: $e');
      Utils.flushBarErrorMessage('Failed to remove all products.', context);
    }
  }

  Future<void> saveOrderToHive(OrderModel product) async {
    try {
      // Check if the box is already open, if not, open it
      var ordersBox = await Hive.openBox('orders'); // Ensure the box is opened

      // Add the order to the box
      await ordersBox.add({
        'products': [product.toJson()], // Wrap the single product in a list
        'totalPrice': calculateTotalPrice(product),
        'timestamp': DateTime.now(),
      });

      print('Order saved to Hive');
    } catch (e) {
      print('Error saving order to Hive: $e');
    }
  }

   void showPaymentDialog(BuildContext context, OrderModel product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomText(
          text: 'Payment Status',
          size: 24,
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        content: CustomText(
          text: 'Select the payment outcome:',
          color: AppColors.greyTransparent500,
          fontWeight: FontWeight.w400,
          size: 15,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Update the order status to 'success'
              OrderModel updatedOrder = product.copyWith(status: 'success');

              // Save successful order, remove from cart, and save to Hive
              await PaymentViewModel().saveOrder(updatedOrder, 'success');
              await PaymentViewModel().removeFromCart(context);
              await PaymentViewModel().saveOrderToHive(updatedOrder);

             
              // Delay navigation to ensure the dialog is fully closed before navigating
              Future.delayed(const Duration(milliseconds: 500), () {
                if (Navigator.canPop(context)) {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesName.orderPage,
                    arguments: updatedOrder,
                  );
                }
              });
            },
            child: CustomText(
              text: 'Success',
              color: AppColors.textPrimaryColor,
              size: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () async {
              // Update the order status to 'failed'
              OrderModel updatedOrder = product.copyWith(status: 'failed');

              // Save failed order, remove from cart, and save to Hive
              await PaymentViewModel().saveOrder(updatedOrder, 'failed');
              await PaymentViewModel().removeFromCart(context);
              await PaymentViewModel().saveOrderToHive(updatedOrder);

             

              // Delay navigation to ensure the dialog is fully closed before navigating
              Future.delayed(const Duration(milliseconds: 500), () {
                if (Navigator.canPop(context)) {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesName.orderPage,
                    arguments: updatedOrder,
                  );
                }
              });
            },
            child: CustomText(
              text: 'Failed',
              color: AppColors.textPrimaryColor,
              size: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    },
  );
}


}
