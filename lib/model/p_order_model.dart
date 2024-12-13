import 'package:hive/hive.dart';
import 'package:stylelezza/model/order_model.dart';

part 'p_order_model.g.dart'; // This must match the file name correctly

@HiveType(typeId: 1) // Ensure typeId is unique in the app
class POrderModel {
  @HiveField(0)
  final String orderStatus; // success or failed

  @HiveField(1)
  final List<OrderModel> products; // List of products

  POrderModel({
    required this.orderStatus,
    required this.products,
  });
}
