import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextInputFormatter 사용을 위해 임포트
import 'login_page.dart';
import 'user_data.dart'; // 이 파일이 서버 통신에 더 이상 필요하지 않을 수 있습니다.
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import

// 전화번호 자동 하이픈 추가 포맷터
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('-', ''); // 입력된 텍스트에서 하이픈 제거

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 전화번호 형식에 맞게 하이픈 추가 (총 11자리 숫자 기준)
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // 010 다음 (3번째 숫자 뒤), 그리고 4자리 숫자 다음 (7번째 숫자 뒤) 하이픈 추가
      if (i == 2 || i == 6) {
         if (i != text.length - 1) { // 마지막 숫자가 아닐 때만 하이픈 추가
           buffer.write('-');
        }
      }
    }

    final formattedText = buffer.toString();

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length), // 커서를 항상 마지막으로 이동
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 이메일 형식 유효성 검사 추가
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    if (!emailRegex.hasMatch(email)) {
      _showErrorDialog('회원가입 실패', '유효한 이메일 주소를 입력해주세요.');
      return;
    }

    // 백엔드로 전송할 전화번호: 하이픈 제거
    final phoneWithoutHyphen = phone.replaceAll('-', '');

    // 전화번호 유효성 검사: 하이픈 제거 후 숫자만 있는지, 길이(10 또는 11) 맞는지 확인
    if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
       final phoneDigitsOnly = phone.replaceAll('-', '');
       final phoneRegex = RegExp(r'^[0-9]+$');
       if (!phoneRegex.hasMatch(phoneDigitsOnly) || (phoneDigitsOnly.length != 10 && phoneDigitsOnly.length != 11)) {
         _showErrorDialog('회원가입 실패', '올바른 전화번호 형식을 입력해주세요 (숫자 10-11자리).');
         return;
       }

      try {
        final url = Uri.parse('http://localhost:8080/api/auth/signup'); // 백엔드 회원가입 엔드포인트 수정
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': name,
            'phone': phoneWithoutHyphen,
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          // 회원가입 성공
          _showSuccessDialog('회원가입 성공', '회원가입이 완료되었습니다. 로그인해주세요.');
          // 성공 시 로그인 페이지로 이동 (바로 이동하거나 다이얼로그 닫은 후 이동 선택)
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginPage()),
          // );
        } else if (response.statusCode == 400) { // 400 Bad Request일 경우
           // 서버에서 보낸 오류 메시지를 그대로 사용
           _showErrorDialog('회원가입 실패', response.body); // 응답 본문을 바로 메시지로 사용
        } else {
          // 기타 서버 응답 오류
          // 서버에서 실패 이유를 응답 본문에 담아준다면 파싱하여 표시 가능
          final errorBody = jsonDecode(response.body); // JSON 파싱 시도
          _showErrorDialog('회원가입 실패', '오류 코드: ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}');
        }
      } catch (e) {
        // 네트워크 오류 등 예외 발생
        _showErrorDialog('회원가입 오류', '네트워크 연결 오류 또는 서버 응답 없음: ${e.toString()}');
      }
    } else {
      _showErrorDialog('회원가입 실패', '모든 필드를 입력해주세요.');
    }
  }

  // 회원가입 성공 시 호출될 다이얼로그 함수 추가
  void _showSuccessDialog(String title, String message) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
               Navigator.pushReplacement( // 로그인 페이지로 이동
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
                hintText: '예: 010-1234-5678', // 힌트 텍스트 추가
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                PhoneNumberFormatter(), // 전화번호 형식 포맷터 적용
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                 filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
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

  @override
  void dispose() {
    // 컨트롤러 dispose
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
