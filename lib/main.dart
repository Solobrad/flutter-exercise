import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';
import 'list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/list', page: () => ListScreen()),
      ],
    );
  }
}
