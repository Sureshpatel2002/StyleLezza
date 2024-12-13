// views/add_product_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/product_model.dart';
import '../../../view_model/admin_view_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAvailable = true;  // Track availability using a regular boolean

  final _product = ProductModel(
    name: '',
    description: '',
    price: 0.0,
    category: '',
    sizes: [],
    images: [],
    isAvailable: true,  // Default availability status
    rating: 0.0,
    stock: 0,
    colors: [],
    id: '',
  );

  void _updateAvailability(bool value) {
    setState(() {
      _isAvailable = value; // Update availability status
      _product.isAvailable = value; // Update the product model
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = Provider.of<AdminViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: adminViewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter product name'
                            : null,
                        onSaved: (value) => _product.name = value!,
                      ),
                      // Description
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onSaved: (value) => _product.description = value ?? '',
                      ),
                      // Price
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || double.tryParse(value) == null
                                ? 'Invalid price'
                                : null,
                        onSaved: (value) =>
                            _product.price = double.parse(value!),
                      ),
                      // Stock
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || int.tryParse(value) == null
                                ? 'Invalid stock'
                                : null,
                        onSaved: (value) => _product.stock = int.parse(value!),
                      ),
                      // Category
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        onSaved: (value) => _product.category = value ?? '',
                      ),
                      // Sizes
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Sizes (comma-separated)'),
                        onSaved: (value) => _product.sizes = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Colors
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Colors (comma-separated)'),
                        onSaved: (value) => _product.colors = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Images
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Image URLs (comma-separated)'),
                        onSaved: (value) => _product.images = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Discount
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Discount (%)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _product.discount =
                            value != null && value.isNotEmpty
                                ? double.parse(value)
                                : null,
                      ),
                      // Rating
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Rating'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _product.rating =
                            value != null && value.isNotEmpty
                                ? double.parse(value)
                                : 0.0,
                      ),
                      // Is Available
                      SwitchListTile(
                        title: const Text('Is Available'),
                        value: _isAvailable,  // Bind to the local boolean variable
                        onChanged: (value) {
                          _updateAvailability(value); // Update the availability
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await adminViewModel.addProduct(_product);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Product'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
