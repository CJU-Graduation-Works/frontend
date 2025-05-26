import 'package:flutter/material.dart';

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
                    // 로그인 상태 초기화 로직
                    Navigator.of(context).popUntil((route) => route.isFirst); // 첫 화면으로 돌아가기
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
