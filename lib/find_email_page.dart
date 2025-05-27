import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextInputFormatter 사용을 위해 임포트 (전화번호 형식 위함)
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // JSON 처리를 위한 import

class FindEmailPage extends StatefulWidget {
  const FindEmailPage({super.key});

  @override
  State<FindEmailPage> createState() => _FindEmailPageState();
}

// 전화번호 자동 하이픈 추가 포맷터 (회원가입 페이지에서 재사용)
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

class _FindEmailPageState extends State<FindEmailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // 전화번호 컨트롤러 추가
  final TextEditingController _codeController = TextEditingController();

  String _sentCode = '';
  int _timerSeconds = 0;
  Timer? _timer;
  bool _isVerified = false;
  List<String> _foundEmails = []; // 찾은 이메일 목록을 저장할 변수 (String에서 List<String>으로 변경)

  void _sendVerificationCode() {
    final random = Random();
    setState(() {
      _sentCode = (1000 + random.nextInt(9000)).toString();
      _timerSeconds = 60;
      _isVerified = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('인증번호: $_sentCode')),
    );
  }

  void _verifyCode() {
    if (_codeController.text == _sentCode) {
      setState(() {
        _isVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 성공!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 실패. 다시 시도해주세요.')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    _phoneController.dispose(); // 전화번호 컨트롤러 dispose 추가
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _findEmails() async { // 메서드 이름 변경 (_findEmail -> _findEmails)
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // 백엔드로 전송할 전화번호: 하이픈 제거
    final phoneWithoutHyphen = phone.replaceAll('-', '');

    if (name.isEmpty || phone.isEmpty) { // 이름과 전화번호 모두 입력했는지 확인
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 전화번호를 모두 입력해주세요.')),
      );
      return;
    }

    // 전화번호 유효성 검사 (선택 사항): 하이픈 제거 후 숫자만 있는지, 길이(10 또는 11) 맞는지 확인
    final phoneDigitsOnly = phone.replaceAll('-', '');
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(phoneDigitsOnly) || (phoneDigitsOnly.length != 10 && phoneDigitsOnly.length != 11)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 전화번호 형식을 입력해주세요 (숫자 10-11자리).')),
      );
      return;
    }

    try {
      // 백엔드 이메일 목록 찾는 엔드포인트 (이름과 전화번호 파라미터 포함)
      final url = Uri.parse('http://localhost:8080/api/auth/find-emails?name=${Uri.encodeComponent(name)}&phone=${Uri.encodeComponent(phoneWithoutHyphen)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 이메일 찾기 성공 (여러 개의 이메일 목록 응답)
        final List<dynamic> responseBody = jsonDecode(response.body);
        final List<String> emails = responseBody.cast<String>(); // String 목록으로 변환

        setState(() {
          _foundEmails = emails; // 찾은 이메일 목록 저장
        });

        if (emails.isNotEmpty) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('${emails.length}개의 이메일을 찾았습니다.')),
             );
        } else {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('해당 정보와 일치하는 사용자를 찾을 수 없습니다.')),
            );
        }

      } else if (response.statusCode == 404) {
        // 해당하는 사용자가 없는 경우
         setState(() {
          _foundEmails = []; // 찾은 이메일 목록 초기화
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('해당 정보와 일치하는 사용자를 찾을 수 없습니다.')),
        );
      }
       else {
        // 기타 서버 응답 오류
         setState(() {
          _foundEmails = []; // 찾은 이메일 목록 초기화
        });
         final errorBody = jsonDecode(response.body); // 오류 응답 파싱
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 찾기 실패: 오류 코드 ${response.statusCode}\n${errorBody['message'] ?? '알 수 없는 오류'}')),
        );
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생
       setState(() {
        _foundEmails = []; // 찾은 이메일 목록 초기화
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 찾기 중 오류 발생: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white), // 흰색 뒤로가기 버튼
        title: const Text(
          '이메일 찾기',
          style: TextStyle(color: Colors.white), // 흰색 텍스트
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 채우기
          children: [
            const SizedBox(height: 60), // 상단 간격
             TextField( // 이름 입력 필드
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
             TextField( // 전화번호 입력 필드 추가
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
               inputFormatters: [ // 입력 포맷터 적용
                 FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                 PhoneNumberFormatter(), // 전화번호 형식 포맷터 적용 (위에 정의된 클래스)
               ],
            ),
            const SizedBox(height: 30), // 필드와 버튼 사이 간격
            ElevatedButton( // 이메일 찾기 버튼
              onPressed: _findEmails, // _findEmails 메서드 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
                foregroundColor: Colors.white, // 흰색 텍스트
                minimumSize: const Size(double.infinity, 48), // 버튼 크기
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('이메일 찾기'), // 버튼 텍스트 변경
            ),
            const SizedBox(height: 30), // 버튼과 결과 표시 사이 간격
            if (_foundEmails.isNotEmpty) // 찾은 이메일 목록이 비어있지 않을 경우에만 표시
              Expanded( // 여러 이메일 표시를 위해 Expanded 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '찾은 이메일 목록:', // 라벨 텍스트 변경
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded( // 이메일 목록이 길어질 경우 스크롤 가능하도록 Expanded 추가
                      child: ListView.builder(
                        itemCount: _foundEmails.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              _foundEmails[index], // 목록에서 이메일 가져와 표시
                              style: const TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
