import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products/controllers/authController.dart';
import 'package:products/controllers/productController.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  AuthController auth = Get.find<AuthController>();
  ProductController product = Get.find<ProductController>();

  // Text Editing Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Method to handle the product addition process
  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      var url = Uri.parse("https://flutter-test-server.onrender.com/api/products");
      var res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.getToken}'
        },
        body: jsonEncode({
          'name': nameController.text,
          'description': descriptionController.text,
          'price': priceController.text
        }),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        product.fetchProducts(auth.getToken);
        Get.snackbar("Success", "Product added successfully");
        Navigator.pop(context);
      } else {
        Get.snackbar("Error", "Failed to add product. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a product name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Product Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a product description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Product Price
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a product price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid price";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB9E453),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: addProduct,
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
