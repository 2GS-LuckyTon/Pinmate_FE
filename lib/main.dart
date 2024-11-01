import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/main_screen.dart';
import './screen/login/login.dart';
import './screen/signup/signup.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  Future<bool> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id') != null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: FutureBuilder<bool>(
            future: _checkSession(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // 스피너 로딩 화면
              } else if (snapshot.hasData && snapshot.data == true) {
                return MainScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
          // routes: {
          //   '/main_screen': (context) => MainScreen(),
          //   '/login': (context) => LoginScreen(),
          //   '/signup': (context) => SignupScreen(),
          // },
        );
      },
    );
  }
}
