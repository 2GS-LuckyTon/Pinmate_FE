import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final ApiService _apiService = ApiService();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final email = _usernameController.text;
      final password = _passwordController.text;
      const image = '1111'; // 이미지 값 설정 (예: 기본 프로필 이미지)

      final response = await _apiService.signup(email, password, image);

      if (response != null) {
        print('Signup successful: $response');
        Navigator.pop(context); // 회원가입 성공 후 이전 화면으로 돌아가기
      } else {
        print('Signup failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("회원가입"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력하세요',
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요!';
                    } else if (value.length > 20) {
                      return '비밀번호는 20자 이내로 입력해주세요!';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호 확인을 입력하세요!';
                    } else if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다!';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 다시 입력하세요',
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
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _signup,
                    child: Container(
                      height: 0.05.sh,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent, width: 1.5),
                      ),
                      child: Center(
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}