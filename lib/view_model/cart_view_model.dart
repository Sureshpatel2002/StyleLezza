import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:stylelezza/model/product_model.dart';
import 'package:stylelezza/utils/utils.dart';

class CartViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProductModel> cartProducts = [];
  bool _isLoading = false;
  double deliveryFees = 25.0;

  bool get isLoading => _isLoading;
  String? get _userId => _auth.currentUser?.uid;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }



/// Fetches cart products for the current user.
Future<void> fetchCartProducts() async {
  if (_userId == null) {
    log('User not logged in! Cannot fetch cart.');
    return;
  }

  log('Fetching cart for user: $_userId at ${DateTime.now()}');
  _setLoading(true);

  try {
    final snapshot = await _firestore
        .collection('cart')
        .doc(_userId) // Use userId as the document ID
        .collection('products') // Fetch products from the sub-collection
        .get();

    log('Total products in cart: ${snapshot.docs.length}');

    // Fetch products from Firestore and convert them to ProductModel
    cartProducts = snapshot.docs.map((doc) {
      log('Fetched product: ${doc.data()}');
      return ProductModel.fromMap(doc.data(), doc.id);
    }).toList();

    log('Successfully fetched ${cartProducts.length} products.');

    // Open Hive box for cart (if not already opened)
    var cartBox = await Hive.openBox('cart'); // Ensure the box is opened

    // Store products in Hive
    for (var product in cartProducts) {
      await cartBox.put(product.id, product.toMap());
      log('Saved product to Hive: ${product.toMap()}');
    }

  } catch (e) {
    log('Error fetching cart products: $e');
  } finally {
    _setLoading(false);
  }
}


  /// Adds a product to the cart.
  Future<void> addToCart(
      ProductModel product, String size, String color, BuildContext context) async {
    if (_userId == null) {
      Utils.flushBarErrorMessage('User not logged in!', context);
      return;
    }

    _setLoading(true);

    try {
      final cartItem = product.copyWith(
        selectedSize: size,
        selectedColor: color,
        uId: _userId!,
        quantity: 1,
       
      );

      // Add the product to the user's cart (under the 'products' sub-collection).
      final productDocRef = _firestore
          .collection('cart')
          .doc(_userId)
          .collection('products')
          .doc(cartItem.id); // Use product ID as the document ID.

      await productDocRef.set(cartItem.toMap());

      log('Product added: ${cartItem.toMap()}');
      Utils.flushBarSuccessMessage('Product added to cart!', context);

      // Refresh the cart.
      await fetchCartProducts();
    } catch (e) {
      log('Error adding product: $e');
      Utils.flushBarErrorMessage('Failed to add product.', context);
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the quantity of a product in the cart.
  Future<void> updateProductQuantity(
      String productId, int newQuantity, BuildContext context) async {
    if (newQuantity < 1) {
      Utils.flushBarErrorMessage('Quantity must be at least 1!', context);
      return;
    }

    try {
      final productDocRef = _firestore
          .collection('cart')
          .doc(_userId)
          .collection('products')
          .doc(productId);

      await productDocRef.update({'quantity': newQuantity});

      final index = cartProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        cartProducts[index] =
            cartProducts[index].copyWith(quantity: newQuantity,);
      }
      notifyListeners();
    } catch (e) {
      log('Error updating product quantity: $e');
      Utils.flushBarErrorMessage('Failed to update quantity.', context);
    }
  }

  /// Removes a product from the cart.
  Future<void> removeFromCart(String productId, BuildContext context) async {
    try {
      final productDocRef = _firestore
          .collection('cart')
          .doc(_userId)
          .collection('products')
          .doc(productId);

      await productDocRef.delete();

      cartProducts.removeWhere((p) => p.id == productId);
      notifyListeners();

      Utils.flushBarSuccessMessage('Product removed from cart!', context);
    } catch (e) {
      log('Error removing product from cart: $e');
      Utils.flushBarErrorMessage('Failed to remove product.', context);
    }
  }

  /// Checks if a product is already in the cart.
  bool isProductInCart(String productId) {
    return cartProducts.any((p) => p.id == productId);
  }

  /// Calculates the subtotal for the cart.
  double get subtotal => cartProducts.fold(
        0.0,
        (sum, item) => sum + ((item.price ?? 0.0) * (item.quantity ?? 1)),
      );

  /// Calculates the total cost including delivery fees.
  double get totalCost => subtotal + deliveryFees;
}
