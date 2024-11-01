import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screen.dart';
import '../signup/signup.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 0.1.sh),
                  const _Logo(),
                  SizedBox(height: 20.h),
                  _FormContent(
                    idController: _idController,
                    passwordController: _passwordController,
                    apiService: _apiService,
                  ),
                  SizedBox(height: 1.0.sh),
                ],
              ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  final TextEditingController idController;
  final TextEditingController passwordController;
  final ApiService apiService;

  const _FormContent({
    Key? key,
    required this.idController,
    required this.passwordController,
    required this.apiService,
  }) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitLogin() async {
    final String email = widget.idController.text.trim();
    final String password = widget.passwordController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true); // Start loading

      final userId = await widget.apiService.login(email, password);

      setState(() => _isLoading = false); // Stop loading

      if (userId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 실패: 이메일이나 비밀번호를 확인하세요.')),
        );
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
              controller: widget.idController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '아이디를 입력하세요!';
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
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력하세요!';
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
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text("회원가입", style: TextStyle(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 16),
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
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
}