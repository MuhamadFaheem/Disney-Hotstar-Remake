import 'package:dinda_app/auth/googleSU.dart';
import 'package:dinda_app/home.dart';
import 'package:dinda_app/auth/phoneSU.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  void showSnackBar(BuildContext context, String message,
      {bool isSuccess = true}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(15, 16, 20, 1),
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // This will hide the default back button/icon
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
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(29, 100, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Masuk atau Daftar", //disney+ login
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Buat profil untuk menikmati berbagai\nfilm dan series favorit Anda",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Container(
                    width: 400, // Set width as needed
                    height: 50, // Set height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0859E0),
                          Color(0xFF053A92),
                          Color(0xFF04307A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add button functionality here
                        // In LoginPage where you navigate to PhoneSignupPage
                        Get.to(
                            () => PhoneSignupPage(showSnackBar: showSnackBar));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.smartphone,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 21,
                          ),
                          Expanded(
                            child: Text(
                              'Masuk dengan nomor telepon',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Container(
                    width: 400, // Set width as needed
                    height: 50, // Set height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0859E0),
                          Color(0xFF053A92),
                          Color(0xFF04307A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add button functionality here
                        Get.to(() => EmailLoginPage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.email_outlined,
                            color: Colors
                                .white, // Match the color of the previous button
                            size: 30,
                          ),
                          SizedBox(
                            width: 21,
                          ),
                          Expanded(
                            child: Text(
                              'Masuk dengan Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // Add some spacing
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Container(
                    width: 400, // Set width as needed
                    height: 50, // Set height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0859E0),
                          Color(0xFF053A92),
                          Color(0xFF04307A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add button functionality here
                        print("Masuk dengan email bro");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/google.png', // Replace with your image asset path
                          ),
                          SizedBox(
                            width: 17,
                          ),
                          Expanded(
                            child: Text(
                              'Masuk dengan Google',
                              style: TextStyle(
                                color: Colors
                                    .white, // Match the color of the previous button
                                fontSize: 19,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      children: [
                        TextSpan(
                            text:
                                'Untuk login yang lebih lancar, ganti ke data seluler. Situs ini dilindungi oleh reCAPTCHA dan Google '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' dan '),
                        TextSpan(
                          text: 'Ketentuan Layanan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' berlaku.'),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 100, left: 10),
                  child: Text(
                    'Mengalami masalah saat masuk?',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 5),
                  child: TextButton(
                    onPressed: () {
                      // Perform login logic here
                      print("HELLOOWWWW");
                    },
                    child: Text(
                      "Dapatkan bantuan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(42, 98, 183, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
