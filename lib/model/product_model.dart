import 'package:hive/hive.dart';

part 'product_model.g.dart'; // Ensure that this is generated with Hive's TypeAdapter code generation

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double? price;

  @HiveField(4)
  String? category;

  @HiveField(5)
  List<String>? sizes;

  @HiveField(6)
  List<String>? images;

  @HiveField(7)
  bool isAvailable; // Storing as a boolean value

  @HiveField(8)
  double? rating;

  @HiveField(9)
  int? stock;

  @HiveField(10)
  List<String>? colors;

  @HiveField(11)
  String? uId;

  @HiveField(12)
  String? selectedColor;

  @HiveField(13)
  String? selectedSize;

  @HiveField(14)
  int? quantity;

  @HiveField(15)
  double? discount;

  @HiveField(16)
  List<String>? tags;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.sizes,
    this.images,
    this.isAvailable = true, // Default value for isAvailable
    this.rating,
    this.stock,
    this.colors,
    this.uId,
    this.selectedColor,
    this.selectedSize,
    this.quantity = 1,
    this.discount,
    this.tags,
  });

  // Factory method to create a ProductModel from a map (useful for Firestore or API)
  factory ProductModel.fromMap(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      isAvailable: data['isAvailable'] ?? true, // Set directly as boolean
      rating: data['rating']?.toDouble() ?? 0.0,
      stock: data['stock'] ?? 0,
      colors: List<String>.from(data['colors'] ?? []),
      uId: data['uId'] ?? '',
      selectedColor: data['selectedColor'] ?? '',
      selectedSize: data['selectedSize'] ?? '',
      quantity: data['quantity'] ?? 1,
      discount: data['discount']?.toDouble() ?? 0.0,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
    );
  }

  // Convert ProductModel to a map (useful for Firestore or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'sizes': sizes,
      'images': images,
      'isAvailable': isAvailable, // Store as boolean
      'rating': rating,
      'stock': stock,
      'colors': colors,
      'uId': uId,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'quantity': quantity,
      'discount': discount,
      'tags': tags,
    };
  }

  // Convert ProductModel to JSON (used for API or storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'sizes': sizes,
      'images': images,
      'isAvailable': isAvailable,
      'rating': rating,
      'stock': stock,
      'colors': colors,
      'uId': uId,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'quantity': quantity,
      'discount': discount,
      'tags': tags,
    };
  }

  // Convert JSON to ProductModel (useful for API or storage)
  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'],
      sizes: List<String>.from(json['sizes'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      rating: json['rating']?.toDouble(),
      stock: json['stock'] ?? 0,
      colors: List<String>.from(json['colors'] ?? []),
      uId: json['uId'],
      selectedColor: json['selectedColor'] ?? '',
      selectedSize: json['selectedSize'] ?? '',
      quantity: json['quantity'] ?? 1,
      discount: json['discount']?.toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  // copyWith method to create a new instance with updated values
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? sizes,
    List<String>? images,
    bool? isAvailable, // Changed to bool from ValueNotifier
    double? rating,
    int? stock,
    List<String>? colors,
    String? uId,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
    double? discount,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      colors: colors ?? this.colors,
      uId: uId ?? this.uId,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      tags: tags ?? this.tags,
    );
  }

  // Factory method for copyWith to be used in a chainable way
  static ProductModel copyWithFactory(ProductModel product, {
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? sizes,
    List<String>? images,
    bool? isAvailable,
    double? rating,
    int? stock,
    List<String>? colors,
    String? uId,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
    double? discount,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? product.id,
      name: name ?? product.name,
      description: description ?? product.description,
      price: price ?? product.price,
      category: category ?? product.category,
      sizes: sizes ?? product.sizes,
      images: images ?? product.images,
      isAvailable: isAvailable ?? product.isAvailable,
      rating: rating ?? product.rating,
      stock: stock ?? product.stock,
      colors: colors ?? product.colors,
      uId: uId ?? product.uId,
      selectedColor: selectedColor ?? product.selectedColor,
      selectedSize: selectedSize ?? product.selectedSize,
      quantity: quantity ?? product.quantity,
      discount: discount ?? product.discount,
      tags: tags ?? product.tags,
    );
  }
}
