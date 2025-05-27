import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_page.dart';
// import 'user_data.dart'; // 서버 통신 시 더 이상 필요 없을 수 있습니다.
import 'find_email_page.dart';
import 'find_password_page.dart';
import 'welcome_page.dart';
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import
import 'user_data.dart'; // UserData import

class LoginPage extends StatefulWidget { // StatefulWidget으로 변경
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { // State 클래스 추가
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() { // dispose 메서드 추가
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    final email = emailController.text.trim(); // 앞뒤 공백 제거
    final password = passwordController.text.trim(); // 앞뒤 공백 제거

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final url = Uri.parse('http://localhost:8080/api/auth/login'); // 백엔드 로그인 엔드포인트
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email, // 백엔드 AuthRequest와 필드 이름 일치
            'password': password, // 백엔드 AuthRequest와 필드 이름 일치
          }),
        );

        if (response.statusCode == 200) {
          // 로그인 성공
          // TODO: 서버로부터 받은 사용자 정보(예: 토큰) 처리 로직 추가
          final prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 가져오기
          prefs.setString('loggedInUserEmail', email); // 이메일 저장
          UserData.email = email; // 로그인한 사용자 이메일 UserData에 저장
          final cameras = await availableCameras();
          final firstCamera = cameras.first;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(cameras: [firstCamera]),
            ),
          );
        } else if (response.statusCode == 401) {
          // 로그인 실패 (이메일 또는 비밀번호 불일치)
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
        else {
          // 기타 서버 응답 오류
          final errorBody = jsonDecode(response.body);
           showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('로그인 실패'),
              content: Text('오류 코드: ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // 네트워크 오류 등 예외 발생
         showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('로그인 오류'),
            content: Text('네트워크 연결 오류 또는 서버 응답 없음: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } else {
      // 이메일 또는 비밀번호가 비어있는 경우
       showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('이메일과 비밀번호를 입력해주세요.'),
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

  @override
  Widget build(BuildContext context) {
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
