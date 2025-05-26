import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'logout_page.dart';
import 'change_password_page.dart';
import 'my_page.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          '내 정보',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 40), // 상단 텍스트와 첫 버튼 사이 간격
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '개인정보 변경',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30), // 버튼 간 간격
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '비밀번호 변경',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30), // 버튼 간 간격
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogoutPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '로그아웃',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
