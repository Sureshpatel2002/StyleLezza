// views/admin_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylelezza/utils/app_colors.dart';

import '../../model/product_model.dart';
import '../../view_model/admin_view_model.dart';
import 'screens/add_product_screen.dart';
import 'screens/edit_product_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminViewModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Admin Panel - Manage Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigate to AddProductScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProductScreen()),
                );
              },
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                size: 24,
              ),
              onPressed: () {
                AdminViewModel().signOut(context);
              },
            )
          ],
        ),
        body: Consumer<AdminViewModel>(
          builder: (context, adminViewModel, child) {
            if (adminViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final products = adminViewModel.products;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: product.images!.isNotEmpty
                        ? Image.network(product.images![0],
                            width: 100, height: 150, fit: BoxFit.cover)
                        : Container(
                            width: 100, height: 100, color: Colors.grey),
                    title: Text(product.name!),
                    subtitle: Text(
                        'Price: ₹${product.price}\nStock: ${product.stock}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to EditProductScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(product: product),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Show Delete Confirmation
                            _showDeleteConfirmation(context, product);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Provider.of<AdminViewModel>(context, listen: false)
                  .deleteProduct(product);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
