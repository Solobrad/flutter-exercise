import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToListScreen();
  }

  void _navigateToListScreen() async {
    // Wait for the logo animation to complete
    await Future.delayed(Duration(seconds: 2));
    Get.offNamed('/list'); // Navigate to the list screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 2),
          child: FlutterLogo(size: 100),
          onEnd: () {
            _navigateToListScreen();
          },
        ),
      ),
    );
  }
}
