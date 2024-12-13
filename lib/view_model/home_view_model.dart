import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stylelezza/model/product_model.dart';



class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Box<ProductModel> _productBox;   // Hive box for products
  late Box<String> _favoriteBox;        // Hive box for favorites
  late Box<String> _carouselImageBox;   // Hive box for carousel images

  List<ProductModel> productList = [];
  List<ProductModel> favoriteList = [];
  List<ProductModel> filterList = [];
  List<String> categories = [];
  List<String> _carouselImages = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<String> get carouselImages => _carouselImages;
List<ProductModel> get filterListForAll => filterList;
 

 Future<void> initialize() async {
    await initHive();      // Initialize Hive
    await fetchProducts(); // Fetch products
    fetchFavorites();      // Load favorites
    await fetchCarouselImages(); // Load carousel images
  }

   /// Initialize Hive boxes
  Future<void> initHive() async {
    _productBox = await Hive.openBox<ProductModel>('products');
    _favoriteBox = await Hive.openBox<String>('favorites');
    _carouselImageBox = await Hive.openBox<String>('carousel_images');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Make sure to call initHive() in initState or constructor
  void _loadFavorites() {
    favoriteList = _favoriteBox.values.map((e) => ProductModel.fromMap({'id': e},e)).toList();
    notifyListeners();
  }

  

  

  /// Fetch products from Firestore or Hive
Future<void> fetchProducts() async {
  _setLoading(true);

  try {
    // Fetch all products from Firestore
    final snapshot = await _firestore.collection('products').get();

    // Clear existing products in Hive
    await _productBox.clear();

    // Map the Firestore documents to ProductModel and save them to Hive
    productList = snapshot.docs.map((doc) {
      final product = ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      _productBox.put(doc.id, product); // Save to Hive
      return product;
    }).toList();

    // Extract categories and set filtered list
    _extractCategories();
    filterList = List.from(productList);

    // Update the UI
    notifyListeners();
  } catch (e) {
    // Handle errors (e.g., network issues)
     log("Failed to fetch products: $e");
  } finally {
    _setLoading(false);
  }
}


  /// Extract unique categories from the product list
  void _extractCategories() {
    categories = productList
        .map((product) => product.category ?? '')
        .toSet()
        .where((category) => category.isNotEmpty)
        .toList();
  }

  /// Filter products by price
  void filterProductsByPrice(double minPrice) {
    filterList = productList.where((product) => product.price! >= minPrice).toList();
    notifyListeners();
  }


// Call this method to display all products when 'All' is selected
  void showAllProducts() {
    filterList = List.from(productList); // Show all products
    notifyListeners();
  }
  /// Filter products by category
  void filterProductsByCategory(String category) {
    filterList = productList
        .where((product) => product.category?.toLowerCase() == category.toLowerCase())
        .toList();
    notifyListeners();
  }

  /// Search products based on query
  void searchProducts(String query) {
    filterList = productList
        .where((product) => product.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

  /// Check if a product is in the favorites
  bool isFavorite(ProductModel product) {
    return _favoriteBox.containsKey(product.id);
  }

  /// Add product to favorites
  Future<void> addToFavorite(ProductModel product) async {
    _favoriteBox.put(product.id, product.id!); // Save favorite by ID
    fetchFavorites();
  }

  /// Remove product from favorites
  Future<void> removeFromFavorite(ProductModel product) async {
    _favoriteBox.delete(product.id); // Remove favorite by ID
    fetchFavorites();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(ProductModel product) async {
    if (isFavorite(product)) {
      await removeFromFavorite(product);
    } else {
      await addToFavorite(product);
    }
  }

  /// Fetch favorites from Hive
  void fetchFavorites() {
    final favoriteIds = _favoriteBox.values.toList();
    favoriteList = productList.where((product) => favoriteIds.contains(product.id)).toList();
    notifyListeners();
  }

Future<void> fetchCarouselImages() async {
  _setLoading(true);

  // Check if images are already saved in Hive
  _carouselImages = _carouselImageBox.values.toList();
  if (_carouselImages.isNotEmpty) {
    debugPrint('Loaded carousel images from Hive');
    _setLoading(false);
    notifyListeners();
    return;
  }

  try {
    // Fetch specific document by ID
    final documentSnapshot = await _firestore.collection('carousel').doc('bY0wn8BSq7QwUqElJtx3').get();

    if (documentSnapshot.exists) {
      // Check if the 'image' field is a list or a single string
      final dynamic imageField = documentSnapshot.data()?['image'];

      if (imageField is List<dynamic>) {
        // Handle if 'image' is a list of images
        final List<String> imageUrls = List<String>.from(imageField);
        for (var imageUrl in imageUrls) {
          await _carouselImageBox.add(imageUrl); // Save each image to Hive
        }
        _carouselImages.addAll(imageUrls);
        debugPrint('Fetched carousel images from Firestore: $imageUrls');
      } else if (imageField is String) {
        // Handle if 'image' is a single string
        await _carouselImageBox.add(imageField);
        _carouselImages.add(imageField);
        debugPrint('Fetched carousel image from Firestore: $imageField');
      } else {
        debugPrint('Image field is neither a list nor a string');
      }
    } else {
      debugPrint('Document does not exist in Firestore');
    }
  } catch (e) {
    debugPrint('Error fetching carousel images: $e');
  }

  _setLoading(false);
  notifyListeners();
}


  /// Clear and save new carousel images to Hive
  Future<void> saveCarouselImages(List<String> images) async {
    _carouselImageBox.clear(); // Clear existing images
    for (var image in images) {
      await _carouselImageBox.add(image);
    }
    _carouselImages = images;
    notifyListeners();
  }

 
}
