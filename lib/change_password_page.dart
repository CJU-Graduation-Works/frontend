import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import
// import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import 제거
import 'user_data.dart'; // UserData import

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async { // async 키워드 추가
    final current = currentPasswordController.text.trim();
    final newPw = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (newPw != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    if (current.isEmpty || newPw.isEmpty || confirm.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    final userEmail = UserData.email; // UserData에서 로그인된 사용자 이메일 가져오기

    if (userEmail == null || userEmail.isEmpty) { // UserData.email이 null 또는 비어있는 경우
      // 로그인된 사용자 이메일이 없는 경우 (예: 앱이 비정상 종료 후 재실행)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 없습니다. 다시 로그인해주세요.')),
      );
      // TODO: 로그인 페이지로 이동하는 로직 추가
      return;
    }

    try {
      final url = Uri.parse('http://localhost:8080/api/auth/change-password'); // 백엔드 비밀번호 변경 엔드포인트
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': userEmail, // 저장된 이메일 사용
          'currentPassword': current,
          'newPassword': newPw,
        }),
      );

      if (response.statusCode == 200) {
        // 비밀번호 변경 성공
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
        );
        Navigator.pop(context); // 성공 후 이전 화면으로
      } else {
        // 비밀번호 변경 실패 (서버 응답 오류)
         final errorBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호 변경 실패: ${errorBody['message'] ?? '알 수 없는 오류'}')),
        );
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 변경 중 오류 발생: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '현재 비밀번호'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '새 비밀번호'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                  ),
                  onPressed: _changePassword,
                  child: const Text(
                    '저장',
                    style: TextStyle(color: Colors.white),
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
