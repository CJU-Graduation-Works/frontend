import 'package:flutter/material.dart';

import 'login_page.dart'; // LoginPage 사용을 위해 임포트

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 상단 배경 흰색 유지
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 검정색 뒤로가기
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Text(
                  '로그아웃 하시겠습니까?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6), // 파란색 예 버튼
                  ),
                  onPressed: () {
                    // 로그인 상태 초기화 로직 (서버 로그아웃 또는 로컬 정보 삭제)
                    // TODO: 로컬에 저장된 로그인 정보(예: 토큰) 삭제 로직 추가 필요
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()), // 로그인 페이지로 이동
                      (route) => false, // 이전 모든 라우트 제거
                    );
                  },
                  child: const Text(
                    '예',
                    style: TextStyle(color: Colors.white), // 흰색 텍스트
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // 이전 화면으로 돌아가기
                  },
                  child: const Text('아니오'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
