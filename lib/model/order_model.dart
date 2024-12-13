import 'package:hive/hive.dart';
import 'product_model.dart'; // Ensure the ProductModel is correctly imported

part 'order_model.g.dart';

@HiveType(typeId: 1) // Unique Type ID for Hive
class OrderModel {
  @HiveField(0)
  final List<ProductModel>? products; // List of products

  @HiveField(1)
  final String? phoneNumber;

  @HiveField(2)
  final String? emailAddress;

  @HiveField(3)
  final String? addressLine1;

  @HiveField(4)
  final String? addressLine2;

  @HiveField(5)
  final String? city;

  @HiveField(6)
  final String? state;

  @HiveField(7)
  final String? pincode;

  @HiveField(8)
  final String? country;

  @HiveField(9)
  final double? totalPrice;

  @HiveField(10)
  final String? status;

  @HiveField(11)
  final DateTime? timeStamp;

  OrderModel({
    this.products,
    this.phoneNumber,
    this.emailAddress,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.totalPrice,
    this.status,
    this.timeStamp,
  });

  // copyWith method to copy the current instance with updated values
  OrderModel copyWith({
    List<ProductModel>? products,
    String? phoneNumber,
    String? emailAddress,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? country,
    double? totalPrice,
    String? status,
    DateTime? timeStamp,
  }) {
    return OrderModel(
      products: products ?? this.products,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  // Convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products?.map((product) => product.toJson()).toList() ?? [],
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'totalPrice': totalPrice,
      'status': status,
      'timeStamp': timeStamp?.toIso8601String(), // Serialize DateTime to ISO string
    };
  }

  // Convert JSON to OrderModel
  static OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel(
      products: (json['products'] as List?)
          ?.map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      country: json['country'],
      totalPrice: json['totalPrice'],
      status: json['status'],
      timeStamp: json['timeStamp'] != null ? DateTime.parse(json['timeStamp']) : null, // Convert from ISO string to DateTime
    );
  }
}
