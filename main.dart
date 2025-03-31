import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import Landing Page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(), // Start with Landing Page
    );
  }
}
