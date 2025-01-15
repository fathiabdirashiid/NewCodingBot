import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products/controllers/authController.dart';
import 'package:products/controllers/productController.dart';

class EditProduct extends StatefulWidget {
  final String id;
  final String name;
  final String? description;
  final double price;

  const EditProduct(
      {super.key,
        required this.id,
        required this.name,
        this.description,
        required this.price});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  AuthController auth = Get.find<AuthController>();
  ProductController product = Get.find<ProductController>();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<void> editProduct() async {
    try {
      // Ensure the URL is correct for the PUT request (added '/' before the id)
      var url = Uri.parse(
          "https://flutter-test-server.onrender.com/api/products/${widget.id}");

      var res = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.getToken}' // Ensure this is correctly fetching token
        },
        body: jsonEncode({
          'name': name.text,
          'description': description.text,
          'price': price.text
        }),
      );

      // Check the response code and display appropriate message
      if (res.statusCode == 200) {
        Get.snackbar("Product", "Edited successfully");
        product.fetchProducts(auth.getToken); // Fetch updated list
        Navigator.pop(context); // Return to previous screen
      } else {
        Get.snackbar("Error", "Failed to edit product");
      }
    } catch (e) {
      Get.snackbar("Error", "Error occurred while editing the product");
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      // Correct URL for DELETE request (added '/' before the id)
      var url = Uri.parse(
          "https://flutter-test-server.onrender.com/api/products/${id}");

      var res = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.getToken}' // Ensure this is correctly fetching token
        },
      );

      // Check response status for success or failure
      if (res.statusCode == 200) {
        Get.snackbar("Product", "Deleted successfully");
        product.fetchProducts(auth.getToken); // Refresh the list
      } else {
        Get.snackbar("Error", "Failed to delete product");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while deleting the product");
    }
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.name);
    description = TextEditingController(text: widget.description ?? ''); // Handle null case for description
    price = TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: price,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB9E453),
                  foregroundColor: Colors.black,
                ),
                onPressed: editProduct,
                child: const Text("Edit"),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF5350), // Red color for Delete
                  foregroundColor: Colors.white,
                ),
                onPressed: () => deleteProduct(widget.id),
                child: const Text("Delete"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
