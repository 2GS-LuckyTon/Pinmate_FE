import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../signup/signup.dart'; // 회원가입 페이지가 있는 위치에 따라 import 경로를 수정하세요.
import '../main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 자동으로 스크롤 조정
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.2.sh), // 상단에 여백 추가
                const _Logo(),
                SizedBox(height: 20.h), // 로고와 폼 사이의 간격
                _FormContent(
                  idController: _idController,
                  passwordController: _passwordController,
                ),
                SizedBox(height: 0.1.sh), // 하단 여백 추가
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        SizedBox(height: 0.35.sw),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({
    Key? key,
    required this.idController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController idController;
  final TextEditingController passwordController;

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ID와 비밀번호를 서버로 전송하는 메서드
  Future<void> _submitLogin() async {
    final String id = widget.idController.text.trim(); // 공백 제거
    final String password = widget.passwordController.text.trim(); // 공백 제거

    // 유효성 검사 통과 후 서버에 전송
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('https://example.com/login'), // 서버 주소로 변경
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'id': id,
            'password': password
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_id', responseData['session_id']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 실패')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: widget.idController, // 변경된 부분
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '빈칸입니다!';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: '아이디를 입력하세요',
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: widget.passwordController, // 변경된 부분
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '빈칸입니다!';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '비밀번호를 입력하세요',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SignupScreen(), // 회원가입 페이지
                    ),
                  );
                },
                child: const Text("회원가입", style: TextStyle(color: Colors.blueAccent)),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _submitLogin,
                child: Container(
                  height: 0.05.sh,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '시작하기',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
