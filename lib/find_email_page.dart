import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FindEmailPage extends StatefulWidget {
  const FindEmailPage({super.key});

  @override
  State<FindEmailPage> createState() => _FindEmailPageState();
}

class _FindEmailPageState extends State<FindEmailPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String _sentCode = '';
  int _timerSeconds = 0;
  Timer? _timer;
  bool _isVerified = false;

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
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
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
          children: [
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: '(-없이 숫자 11자리 입력)',
                suffix: ElevatedButton(
                  onPressed: _sendVerificationCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[200],
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('인증번호 받기', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '인증번호 4자리',
                suffix: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('인증확인', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_timerSeconds > 0)
              Text(
                '남은 시간: $_timerSeconds초',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isVerified
                  ? () {
                // 인증 완료 후 다음 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이메일: example@email.com')),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200],
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
