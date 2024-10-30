import 'package:flutter/material.dart';
import './screen/main_screen.dart';
import 'package:shared_map_app/screen/signup/signup.dart';
import './screen/login/login.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/main_screen',
      routes: {
        '/main_screen' : (context)=>MainScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}