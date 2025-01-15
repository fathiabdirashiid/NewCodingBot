import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products/controllers/authController.dart';
import 'package:products/controllers/productController.dart';
import 'package:products/screens/addProduct.dart';
import 'package:products/screens/editProduct.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  AuthController auth = Get.find<AuthController>();
  final ProductController products = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    products.fetchProducts(auth.getToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.inventory),
              title: Text(
                products.products[index].name,
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                "\$ ${products.products[index].price.toString()}",
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                onPressed: () {
                  products.deleteProduct(
                      auth.getToken, products.products[index].id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Get.to(
                  EditProduct(
                    id: products.products[index].id,
                    name: products.products[index].name,
                    description: products.products[index].description,
                    price: products.products[index].price,
                  ),
                );
              },
            );
          },
          itemCount: products.products.length,
          padding: EdgeInsets.all(0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddProduct());
        },
        child: Text("+"),
      ),
    );
  }
}
