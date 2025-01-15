import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products/controllers/authController.dart';
import 'package:products/controllers/productController.dart';
import 'package:products/layout.dart';

void main() async {
  Get.put(AuthController());
  Get.put(ProductController());
  runApp(
    GetMaterialApp(
      home: Layout(),
    ),
  );
}
