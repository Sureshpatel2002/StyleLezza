// views/edit_product_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/product_model.dart';
import '../../../view_model/admin_view_model.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductModel _product;

  @override
  void initState() {
    super.initState();
    _product = ProductModel(
      id: widget.product.id,
      name: widget.product.name,
      description: widget.product.description,
      price: widget.product.price,
      category: widget.product.category,
      sizes: List.from(widget.product.sizes!),
      images: List.from(widget.product.images!),
      isAvailable: widget.product.isAvailable,
      rating: widget.product.rating,
      stock: widget.product.stock,
      colors: List.from(widget.product.colors!),
      discount: widget.product.discount,
      tags: widget.product.tags != null ? List.from(widget.product.tags!) : null,
    );
  }

  void _updateAvailability(bool value) {
    setState(() {
      _product.isAvailable = value; // Directly update the product's availability
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = Provider.of<AdminViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
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
                        initialValue: _product.name,
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter product name'
                            : null,
                        onSaved: (value) => _product.name = value!,
                      ),
                      // Description
                      TextFormField(
                        initialValue: _product.description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onSaved: (value) => _product.description = value ?? '',
                      ),
                      // Price
                      TextFormField(
                        initialValue: _product.price.toString(),
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
                        initialValue: _product.stock.toString(),
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
                        initialValue: _product.category,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        onSaved: (value) => _product.category = value ?? '',
                      ),
                      // Sizes
                      TextFormField(
                        initialValue: _product.sizes!.join(', '),
                        decoration: const InputDecoration(
                            labelText: 'Sizes (comma-separated)'),
                        onSaved: (value) => _product.sizes = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Colors
                      TextFormField(
                        initialValue: _product.colors!.join(', '),
                        decoration: const InputDecoration(
                            labelText: 'Colors (comma-separated)'),
                        onSaved: (value) => _product.colors = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Images
                      TextFormField(
                        initialValue: _product.images!.join(', '),
                        decoration: const InputDecoration(
                            labelText: 'Image URLs (comma-separated)'),
                        onSaved: (value) => _product.images = value != null
                            ? value.split(',').map((s) => s.trim()).toList()
                            : [],
                      ),
                      // Discount
                      TextFormField(
                        initialValue: _product.discount?.toString() ?? '0',
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
                        initialValue: _product.rating.toString(),
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
                        value: _product.isAvailable,  // Bind directly to the isAvailable field
                        onChanged: _updateAvailability,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            log('Product data saved: ${_product.toMap()}'); // Log the product data before updating
                            await adminViewModel.updateProduct(_product);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Update Product'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
