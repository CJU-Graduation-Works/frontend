import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import
import 'package:flutter/services.dart'; // PhoneNumberFormatter 사용
import 'signup_page.dart'; // PhoneNumberFormatter 사용을 위해 임포트 ( PhoneNumberFormatter 클래스 정의 포함 )
import 'user_data.dart'; // 사용자 이메일 정보 가져오기 (가정)
import 'edit_profile_page.dart';
import 'logout_page.dart';
import 'change_password_page.dart';
import 'my_page.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _email = UserData.email ?? ''; // UserData.email 사용 및 null 체크

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 페이지 초기화 시 사용자 정보 로드
  }

  // 백엔드에서 사용자 정보를 가져와 필드에 설정
  Future<void> _loadUserInfo() async {
    if (_email.isEmpty) { // 이메일 정보가 없으면 로드하지 않음
      _showAlert('오류', '로그인된 사용자 정보가 없습니다.');
      return;
    }
    try {
      final url = Uri.parse('http://localhost:8080/api/auth/user-info?email=${Uri.encodeComponent(_email)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userInfo = jsonDecode(response.body);
        setState(() {
          _nameController.text = userInfo['name'] ?? '';
          _phoneController.text = userInfo['phone'] ?? '';
          // 이메일은 이미 설정되어 있음
        });
      } else if (response.statusCode == 404) {
         _showAlert('오류', '사용자 정보를 찾을 수 없습니다.');
      } else {
         final errorBody = jsonDecode(response.body);
         _showAlert('오류', '사용자 정보 로드 실패: 오류 코드 ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
       _showAlert('오류', '사용자 정보 로드 중 오류 발생: ${e.toString()}');
    }
  }

  // 변경된 정보를 백엔드로 전송하는 로직
  void _updateUserInfo() async {
    final updatedName = _nameController.text.trim();
    final updatedPhone = _phoneController.text.trim().replaceAll('-', ''); // 하이픈 제거

    if (_email.isEmpty || updatedName.isEmpty || updatedPhone.isEmpty) {
       _showAlert('오류', '모든 필드를 입력해주세요.');
       return;
    }

     // 전화번호 유효성 검사 (선택 사항): 숫자만 있는지, 길이(10 또는 11) 맞는지 확인
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(updatedPhone) || (updatedPhone.length != 10 && updatedPhone.length != 11)) {
      _showAlert('오류', '올바른 전화번호 형식을 입력해주세요 (숫자 10-11자리).');
      return;
    }

    try {
      final url = Uri.parse('http://localhost:8080/api/auth/user-info'); // PUT 엔드포인트
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _email, // 어떤 사용자를 업데이트할지 식별
          'name': updatedName,
          'phone': updatedPhone,
        }),
      );

      if (response.statusCode == 200) {
        _showAlert('성공', '사용자 정보가 성공적으로 업데이트되었습니다.');
      } else if (response.statusCode == 404) {
        _showAlert('오류', '사용자를 찾을 수 없어 정보를 업데이트할 수 없습니다.');
      } else {
         final errorBody = jsonDecode(response.body);
         _showAlert('오류', '사용자 정보 업데이트 실패: 오류 코드 ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
       _showAlert('오류', '사용자 정보 업데이트 중 오류 발생: ${e.toString()}');
    }
  }

    // 다이얼로그 표시 함수 (기존 함수 재사용 또는 새로 정의)
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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 채우기
            children: [
              const SizedBox(height: 40), // 상단 간격
              // 이메일 정보 표시 (수정 불가)
              Text(
                '이메일: ${_email}', // UserData.email 값을 표시
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30), // 간격

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
              const SizedBox(height: 20), // 필드 간 간격

              TextField( // 전화번호 입력 필드
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
                  PhoneNumberFormatter(), // 전화번호 형식 포맷터 적용 (signup_page.dart에서 가져옴)
                ],
              ),
              const SizedBox(height: 40), // 필드와 버튼 사이 간격

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateUserInfo, // 업데이트 함수 호출
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '정보 수정',
                    style: TextStyle(color: Colors.white), // 흰색 텍스트
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
