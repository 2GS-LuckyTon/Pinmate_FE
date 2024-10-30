import 'package:flutter/material.dart';
import './screen/main_screen.dart';
import 'package:shared_map_app/screen/signup/signup.dart';
import './screen/login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 디자인 사이즈 설정
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          initialRoute: '/main_screen',
          routes: {
            '/main_screen': (context) => MainScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
          },
        );
      },
    );
  }
}