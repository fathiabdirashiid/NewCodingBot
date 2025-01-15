import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:products/controllers/authController.dart';
import 'package:products/layout.dart';
import 'package:products/screens/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";
  AuthController auth = Get.find<AuthController>();

  Future<void> _login() async {
    if (_email.isEmpty || _password.isEmpty) {
      Get.snackbar("Fields are required", "Email and Password fields are required");
      return;
    }

    final url = Uri.parse("https://flutter-test-server.onrender.com/api/users/login");
    final response = await http.post(url,
        body: jsonEncode({'email': _email, 'password': _password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      auth.setToken(data['token']);
      Get.to(Layout());
    } else {
      Get.snackbar("Error", "Error while login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7), // Light background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Image with ClipOval
                ClipOval(
                  child: Image.network(
                    'https://media-mba2-1.cdn.whatsapp.net/v/t61.24694-24/418546075_430410966491702_421832997420594542_n.jpg?stp=dst-jpg_s96x96_tt6&ccb=11-4&oh=01_Q5AaIAhuDcu9KCOry9KJo3fanE2QqUYOIhae7oLjV4x2d4XH&oe=67949D18&_nc_sid=5e03e0&_nc_cat=100',  // Replace with your image URL
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),  // Add space between logo and fields

                // Email input field with improved design
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.mail, color: Colors.grey[600]),
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(color: Colors.grey[200]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Password input field with improved design
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.key, color: Colors.grey[600]),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(color: Colors.grey[200]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 30),

                // Login button with new styling
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[310], // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Sign Up Text Button with improved text styling
                TextButton(
                  onPressed: () {
                    Get.to(Signup());
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
