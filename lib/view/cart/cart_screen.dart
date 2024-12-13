import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/element/custom_buttom.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/model/order_model.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/constant_padding.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/view_model/cart_view_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartViewModel>(context, listen: false).fetchCartProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          title:  CustomText(text: 'My Cart',color: AppColors.textSubH3Color,size: 20,),
        ),
        body: Consumer<CartViewModel>(
          builder: (context, cartViewModel, child) {
            if (cartViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cartViewModel.cartProducts.isEmpty) {
              return const Center(
                child: CustomText(
                  text: 'Your cart is empty!',
                  size: 18,
                  color: Colors.black,
                ),
              );
            }

            return ListView.builder(
              itemCount: cartViewModel.cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartViewModel.cartProducts[index];
                return CartItem(
                  product: product,
                  onUpdateQuantity: (newQuantity) {
                    cartViewModel.updateProductQuantity(
                      product.id!,
                      newQuantity,
                      context,
                    );
                  },
                  onRemove: () {
                    cartViewModel.removeFromCart(product.id!, context);
                  },
                );
              },
            );
          },
        ),
        bottomSheet: _buildBottomSheet(context),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.backgroundColor,
      child: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          double subtotal = cartViewModel.cartProducts.fold(
            0.0,
            (sum, item) => sum + (item.price! * (item.quantity ?? 1)),
          );

          double deliveryFees = 25.0;
          double totalCost = subtotal + deliveryFees;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('Subtotal:', '₹${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildSummaryRow(
                  'Delivery Fees:', '₹${deliveryFees.toStringAsFixed(2)}'),
              const Divider(),
              _buildSummaryRow(
                'Total Cost:',
                '₹${totalCost.toStringAsFixed(2)}',
                isBold: true,
              ),
              const SizedBox(height: 8),
              CustomButton(
                child: CustomText(
                  text: 'Proceed to checkout',
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
                fullsize: true,
                onTap: () {
                  // Create a single OrderModel that contains all the products
                  double totalPrice = cartViewModel.cartProducts.fold(
                        0.0,
                        (sum, product) =>
                            sum + (product.price! * (product.quantity ?? 1)),
                      ) +
                      25.0; // Add delivery fees

                  OrderModel order = OrderModel(
                    products: cartViewModel.cartProducts, // All cart products
                    totalPrice:
                        totalPrice, // Total price including delivery fees
                  );

                  Navigator.pushNamed(
                    context,
                    RoutesName.checkoutPage,
                    arguments: order, // Pass the single OrderModel
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          size: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        CustomText(
          text: value,
          size: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}

class CartItem extends StatelessWidget {
  final dynamic product;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItem({
    required this.product,
    required this.onUpdateQuantity,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quantity = product.quantity ?? 1;
    String imageUrl = product.images!.isNotEmpty ? product.images!.first : '';

    return Padding(
      padding: EdgeInsets.all(ResponsivePadding.getPagePadding(context)),
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0.5,
        color: AppColors.whiteColor,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    text: product.name!,
                    size: 12,
                    maxline: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: "Size: ${product.selectedSize}",
                    color: AppColors.greyTransparent400,
                    size: 10,
                  ),
                  CustomText(
                    text: "Price: ₹${product.price}",
                    size: 12,
                  ),
                ],
              ),
            ),
            
            Row(
              
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) onUpdateQuantity(quantity - 1);
                  },
                  icon: const Icon(Icons.remove, color: AppColors.buttonColor),
                ),
                CustomText(text: "$quantity"),
                IconButton(
                  onPressed: () => onUpdateQuantity(quantity + 1),
                  icon: const Icon(Icons.add, color: AppColors.buttonColor),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
