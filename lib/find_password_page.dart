import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import
import 'login_page.dart'; // 로그인 페이지로 이동을 위해 임포트

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController(); // 새 비밀번호 컨트롤러 추가
  final confirmPasswordController = TextEditingController(); // 새 비밀번호 확인 컨트롤러 추가

  String _temporaryCode = ''; // 임시로 인증 코드를 저장할 변수 추가
  bool _isCodeVerified = false; // 인증 상태를 관리할 변수 추가

  // 인증번호 요청 로직 (백엔드 연동)
  void sendVerificationCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showAlert('오류', '유효한 이메일 주소를 입력해주세요.');
      return;
    }

    try {
      final url = Uri.parse('http://localhost:8080/api/auth/send-verification-code');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // 성공 응답 본문에 인증 코드가 포함되어 있다고 가정 (개발 목적)
        // 실제 운영 환경에서는 이 코드를 제거해야 합니다.
        try {
          final responseBody = jsonDecode(response.body); // 응답 본문 파싱 시도
          if (responseBody != null && responseBody is Map && responseBody.containsKey('code')) {
            setState(() {
              _temporaryCode = responseBody['code']; // 응답에서 코드 가져오기
              _isCodeVerified = false; // 코드 재발송 시 인증 상태 초기화
            });
            _showAlert('성공', '인증 코드가 발송되었습니다. 이메일을 확인해주세요. (개발용 코드: ${_temporaryCode})');
          } else {
            // 응답 본문에 코드가 없을 경우 기본 메시지 표시
            setState(() {
              _temporaryCode = ''; // 임시 코드 초기화
              _isCodeVerified = false; // 인증 상태 초기화
            });
            _showAlert('성공', '인증 코드가 발송되었습니다. 이메일을 확인해주세요. (개발용 코드 확인 불가)');
          }
        } catch (e) {
          // JSON 파싱 오류 또는 기타 오류 발생 시
          setState(() {
            _temporaryCode = ''; // 임시 코드 초기화
            _isCodeVerified = false; // 인증 상태 초기화
          });
          _showAlert('성공', '인증 코드가 발송되었습니다. 이메일을 확인해주세요. (개발용 코드 표시 중 오류)');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _temporaryCode = ''; // 임시 코드 초기화
          _isCodeVerified = false; // 인증 상태 초기화
        });
        _showAlert('오류', '해당 이메일의 사용자를 찾을 수 없습니다.');
      } else {
        setState(() {
          _temporaryCode = ''; // 임시 코드 초기화
          _isCodeVerified = false; // 인증 상태 초기화
        });
        final errorBody = jsonDecode(response.body);
        _showAlert('오류', '인증 코드 발송 실패: ${errorBody['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      setState(() {
        _temporaryCode = ''; // 임시 코드 초기화
        _isCodeVerified = false; // 인증 상태 초기화
      });
      _showAlert('오류', '네트워크 오류 또는 서버 응답 없음: ${e.toString()}');
    }
  }

  // 인증 코드 확인 로직 (프론트엔드 임시 확인)
  void _verifyCode() {
    final enteredCode = codeController.text.trim();
    if (_temporaryCode.isNotEmpty && enteredCode == _temporaryCode) {
      setState(() {
        _isCodeVerified = true; // 인증 성공 시 상태 변경
      });
      _showAlert('성공', '인증이 완료되었습니다. 이제 비밀번호를 재설정할 수 있습니다.');
    } else {
      setState(() {
         _isCodeVerified = false; // 인증 실패 시 상태 초기화
      });
      _showAlert('실패', '인증번호가 올바르지 않습니다.');
    }
  }

  // 비밀번호 재설정 로직 (백엔드 연동)
  void resetPassword() async { // 메서드 이름 변경 complete -> resetPassword
    if (!_isCodeVerified) { // 인증이 완료되지 않았으면 실행하지 않음
       _showAlert('오류', '먼저 인증을 완료해주세요.');
       return;
    }

    final email = emailController.text.trim();
    final code = codeController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || code.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showAlert('오류', '모든 필드를 입력해주세요.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showAlert('오류', '새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
      return;
    }

    try {
      final url = Uri.parse('http://localhost:8080/api/auth/reset-password');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showAlert('성공', '비밀번호가 성공적으로 재설정되었습니다. 로그인해주세요.');
        // 성공 시 로그인 페이지로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false, // 이전 라우트 모두 제거
        );
      } else if (response.statusCode == 400) {
         final errorBody = jsonDecode(response.body);
        _showAlert('오류', '비밀번호 재설정 실패: ${errorBody['message'] ?? '인증 코드가 유효하지 않습니다.'}');
      } else {
         final errorBody = jsonDecode(response.body);
         _showAlert('오류', '비밀번호 재설정 실패: 오류 코드 ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      _showAlert('오류', '네트워크 오류 또는 서버 응답 없음: ${e.toString()}');
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
            onPressed: () => Navigator.pop(context), // 다이얼로그만 닫기
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose(); // 새 비밀번호 컨트롤러 dispose
    confirmPasswordController.dispose(); // 새 비밀번호 확인 컨트롤러 dispose
    super.dispose();
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
                  onPressed: sendVerificationCode, // 인증번호 발송 함수 호출
                  child: const Text('인증번호 받기'),
                ),
                border: const UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            Row( // 인증번호 입력 필드와 인증확인 버튼을 가로로 배치
              children: [
                Expanded( // TextField가 남은 공간을 모두 차지하도록 Expanded 사용
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: '인증번호 4자리 입력',
                      border: const UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8), // 간격 추가
                ElevatedButton( // 인증확인 버튼 추가
                  onPressed: _verifyCode, // _verifyCode 함수 호출
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCodeVerified ? Colors.green : const Color(0xFF3B82F6), // 인증 상태에 따라 색상 변경 (선택 사항)
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('인증확인'),
                ),
              ],
            ),
            if (_temporaryCode.isNotEmpty) // 임시 코드가 있을 경우에만 표시
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  '개발용 임시 코드: ${_temporaryCode}', // 임시 코드 표시
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 24), // 간격 추가

            if (_isCodeVerified) // 인증이 완료되었을 때만 새 비밀번호 입력 필드와 버튼 표시
              Column( // 새 비밀번호 관련 위젯들을 Column으로 묶음
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField( // 새 비밀번호 입력 필드 추가
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      hintText: '새 비밀번호 입력',
                      border: const UnderlineInputBorder(),
                    ),
                    obscureText: true, // 비밀번호 숨김
                  ),
                  const SizedBox(height: 24), // 간격 추가
                  TextField( // 새 비밀번호 확인 입력 필드 추가
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: '새 비밀번호 확인',
                      border: const UnderlineInputBorder(),
                    ),
                    obscureText: true, // 비밀번호 숨김
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: resetPassword, // 비밀번호 재설정 함수 호출
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
                        foregroundColor: Colors.white, // 흰색 텍스트
                      ),
                      child: const Text('비밀번호 재설정'), // 버튼 텍스트 변경
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
