import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_data.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signup() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // 서버 없이 회원가입 처리
      UserData.email = email;
      UserData.password = password;

      // 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      _showErrorDialog('회원가입 실패', '모든 필드를 입력해주세요.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),  // 푸른색 배경
        centerTitle: true,                          // 타이틀 중앙 정렬
        title: const Text(
          '회원가입',
          style: TextStyle(color: Colors.white),  // 흰색 텍스트
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 흰색 뒤로가기 아이콘
          onPressed: () => Navigator.pop(context),                   // 이전 페이지로 돌아가기
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // 버튼 가로 꽉 채우기
              child: ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '회원가입 완료',
                  style: TextStyle(color: Colors.white), // 흰색 텍스트
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
