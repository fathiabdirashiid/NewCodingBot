import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:products/Product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;

  Future<void> fetchProducts(String token) async {
    try {
      final res = await http.get(
        Uri.parse("https://flutter-test-server.onrender.com/api/products"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        products.value = data.length > 0
            ? data.map<Product>((data) => Product.fromJson(data)).toList()
            : [];
      } else {
        Get.snackbar("Error", "Failed to fetch products");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching tasks");
    }
  }

  Future<void> deleteProduct(String token, String id) async {
    try {
      var url = Uri.parse(
          "https://flutter-test-server.onrender.com/api/products${id}");
      var res = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        Get.snackbar("Product", "deleted successfully");
        fetchProducts(token);
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting product");
    }
  }
}


























