// view_models/admin_viel.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product_model.dart';
import '../utils/routes/route_name.dart';

class AdminViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();

      _products = snapshot.docs
          .map((doc) =>
              ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      log('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a product to Firestore
  Future<void> addProduct(ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add the product and get the document reference
      DocumentReference docRef =
          await _firestore.collection('products').add(product.toMap());

      // Set the generated ID in the product model
      product.id = docRef.id;

      // Add the product to the local list
      _products.add(product);
      notifyListeners(); // Notify listeners after adding the product
    } catch (e) {
      log('Error adding product: $e');
    } finally {
      _isLoading = false; // Ensure loading state is reset
      notifyListeners(); // Notify listeners after changing loading state
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    _isLoading = true; // Start loading
    notifyListeners();

    // Check if the product ID is valid
    if (product.id!.isEmpty) {
      return log('Product ID cannot be empty');
    }

    try {
      // Update the product in Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id) // Ensure this is not empty
          .update(product.toMap());

      _isLoading = false; // Stop loading
      notifyListeners(); // Notify listeners about the loading state change
    } catch (e) {
      _isLoading = false; // Stop loading in case of error
      notifyListeners(); // Notify listeners about the loading state change

      // Handle exceptions accordingly
      print('Error updating product: $e');
    }
  }

  // Delete a product from Firestore
  Future<void> deleteProduct(ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('products').doc(product.id).delete();
      _products.removeWhere((p) => p.id == product.id);
    } catch (e) {
      log('Error deleting product: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Save user data to SharedPreferences
  Future<void> saveUserDataToSharedPrefs(
      {required String uid,
      required String email,
      required String username,
      required bool isAdmin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('username', username);
    await prefs.setBool('isAdmin', isAdmin);
    if (kDebugMode) {
      log('User data saved to SharedPreferences: $uid, $email, $username');
    }
  }

  // Retrieve user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? email = prefs.getString('email');
    String? username = prefs.getString('username');
    bool? isAdmin = prefs.getBool('isAdmin');

    if (uid != null && email != null && username != null && isAdmin != null) {
      if (kDebugMode) {
        log('User data retrieved from SharedPreferences: $uid');
      }
      return {
        'uid': uid,
        'email': email,
        'username': username,
        'isAdmin': isAdmin,
      };
    }
    if (kDebugMode) {
      log('No user data found in SharedPreferences');
    }
    return null;
  }

  // Clear user data from SharedPreferences
  Future<void> clearUserDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('isAdmin');
    if (kDebugMode) {
      log('User data cleared from SharedPreferences');
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    if (kDebugMode) {
      log('Signing out user');
    }
    await _auth.signOut();
    await clearUserDataFromSharedPrefs();
    if (kDebugMode) {
      log('User signed out successfully');
    }
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
  }
}
