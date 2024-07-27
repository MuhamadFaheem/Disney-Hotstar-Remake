import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF010A3E),
            Color(0xFF0000A9),
          ],
          stops: [0.3508, 1.0], // Adjust stops if needed
        ),
      ),
      child: Center(
        // Add your logo or any other content here
        child: Image.asset(
          'assets/disney.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
