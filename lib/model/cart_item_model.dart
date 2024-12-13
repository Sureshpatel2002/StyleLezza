class CartItemModel {
  final String productId; // Unique identifier for the product
  final String name;      // Name of the product
  final double price;     // Price of the product
  final String sizes; // List of sizes for the product
  final String color;     // Color of the product
  final String uid;       // User ID who added the product to the cart
  final List<String> images;
   int? quantity; // List of image URLs for the product

  // Constructor to initialize the CartItemModel
  CartItemModel(
     {
    required this.productId,
    required this.name,
    required this.price,
    required this.sizes,
    required this.color,

    required this.uid,
    required this.images,
    this.quantity
  });

  // Method to convert a CartItemModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'sizes': sizes,
      'color': color,
      'uid': uid,
      'images': images,
      'quantity':quantity
    };
  }

  // Factory constructor to create a CartItemModel from a map
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      sizes: map['sizes'],
      color: map['color'],
      uid: map['uid'],
      images: List<String>.from(map['images']),
      quantity: map['quantity'],
    );
  }
}
