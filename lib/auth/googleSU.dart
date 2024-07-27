import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dinda_app/home%20copy.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth package
import 'package:get/get.dart';
import '../home.dart'; // Assuming this is where your EmailOtpPage is defined

class EmailLoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/disney.png",
              fit: BoxFit.contain,
              height: 60,
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(21, 24, 31, 0.92),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
              right: 30.0,
              left: 30.0,
              bottom: 30.0,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Masuk atau daftar untuk melanjutkan',
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.grey[500]),
                      ),
                      SizedBox(height: 70.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                filled: true,
                                fillColor: Color.fromRGBO(217, 217, 217, 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            PasswordFormField(
                              controller: _passwordController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () {
                          // Add functionality here
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      // Button login
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50.0,
                  right: 16.0,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Text(
                          'Mengalami masalah saat masuk?',
                          style: TextStyle(
                            color: Color.fromRGBO(95, 94, 94, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle onTap action here
                            print("Dapatkan bantuan clicked");
                          },
                          child: Text(
                            "Dapatkan bantuan",
                            style: TextStyle(
                              color: Color.fromRGBO(42, 98, 183, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration
                                  .underline, // Optional: Add underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 130.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is validated, proceed with Firebase login
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          print('User logged in: ${userCredential.user!.uid}');
                          Get.snackbar("Login Success", "Welcome back",
                              backgroundColor: Colors.green[400],
                              icon: Icon(
                                Icons.check_circle_outline,
                                color: Colors.black,
                              ));
                          Future.delayed(Duration(seconds: 2), () {
                            // Navigate to another page after delay
                            Get.to(() => HomePageTest());
                          });
                        } catch (e) {
                          print('Login failed: $e');
                          Get.snackbar(
                              'Login Failed', "Invalid email or password",
                              icon: Icon(
                                Icons.error_outline,
                                color: Colors.black,
                              ),
                              backgroundColor: Colors.redAccent);
                          // Handle login errors here
                          // You can show a snackbar or dialog to the user
                        }
                      }
                    },
                    tooltip: 'Login',
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0859E0),
                            Color(0xFF053A92),
                            Color(0xFF04307A),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 60,
                      ),
                    ),
                    foregroundColor: Colors.white,
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

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFormField({required this.controller});

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(217, 217, 217, 1),
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
