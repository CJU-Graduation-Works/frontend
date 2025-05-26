import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'user_data.dart';
import 'find_email_page.dart';
import 'find_password_page.dart';
import 'welcome_page.dart';  // welcome_page 임포트 꼭 추가하세요

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void login() async {
      final email = emailController.text;
      final password = passwordController.text;

      if (email == UserData.email && password == UserData.password) {
        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(cameras: [firstCamera]),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('로그인 실패'),
            content: const Text('이메일 또는 비밀번호가 일치하지 않습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3B82F6), // 파란색 배경
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          '이메일 로그인',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '이메일 주소',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('이메일 로그인'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FindEmailPage()),
                    );
                  },
                  child: const Text(
                    '이메일 찾기',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                const Text('|', style: TextStyle(fontSize: 14, color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FindPasswordPage()),
                    );
                  },
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
