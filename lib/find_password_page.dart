import 'dart:math';
import 'package:flutter/material.dart';
import 'reset_password_page.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  String? verificationCode; // ✅ 여기에 저장!
  bool codeSent = false;
  bool codeVerified = false;

  // 인증번호 생성 함수 (4자리 숫자)
  String generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // 인증번호 요청 로직
  void sendVerificationCode() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showAlert('오류', '유효한 이메일 주소를 입력해주세요.');
      return;
    }

    setState(() {
      verificationCode = generateVerificationCode();
      codeSent = true;
      codeVerified = false;
    });

    // 실제 앱에서는 이메일 전송 로직이 필요함
    _showAlert('인증번호 전송됨', '인증번호가 전송되었습니다: $verificationCode');
  }

  // 인증번호 확인 로직
  void verifyCode() {
    final enteredCode = codeController.text.trim();
    if (enteredCode == verificationCode) {
      setState(() {
        codeVerified = true;
      });
      _showAlert('성공', '인증이 완료되었습니다.');
    } else {
      _showAlert('실패', '인증번호가 올바르지 않습니다.');
    }
  }

  // 완료 버튼 클릭 시
  void complete() {
    if (codeVerified) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
      );
    } else {
      _showAlert('실패', '인증을 완료해주세요.');
    }
  }

  // 다이얼로그 표시 함수
  void _showAlert(String title, String message) {
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
        leading: const BackButton(color: Colors.white), // 흰색 뒤로가기 버튼
        title: const Text(
          '비밀번호 찾기',
          style: TextStyle(color: Colors.white), // 흰색 텍스트
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: '이메일 주소 입력',
                suffix: TextButton(
                  onPressed: sendVerificationCode,
                  child: const Text('인증번호 받기'),
                ),
                border: const UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: '인증번호 4자리 입력',
                suffix: TextButton(
                  onPressed: verifyCode,
                  child: const Text('인증확인'),
                ),
                border: const UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: complete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                ),
                child: const Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
