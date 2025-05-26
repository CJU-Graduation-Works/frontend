import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  Future<void> _kakaoLogin(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      print('카카오 로그인 성공: ${token.accessToken}');

      User user = await UserApi.instance.me();
      print('사용자 닉네임: ${user.kakaoAccount?.profile?.nickname}');
      print('사용자 이메일: ${user.kakaoAccount?.email}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.kakaoAccount?.profile?.nickname}님 환영합니다!')),
      );
    } catch (error) {
      print('카카오 로그인 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카카오 로그인에 실패했습니다.')),
      );
    }
  }

  Future<void> _googleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print('구글 로그인 취소됨');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('구글 로그인 성공: ${googleAuth.accessToken}');
      print('사용자 이름: ${googleUser.displayName}');
      print('사용자 이메일: ${googleUser.email}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${googleUser.displayName}님 환영합니다!')),
      );
    } catch (error) {
      print('구글 로그인 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구글 로그인에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),

                // 카카오 로그인 버튼
                ElevatedButton.icon(
                  onPressed: () => _kakaoLogin(context),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                  label: const Text(
                    '카카오 계정으로 시작하기',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 구글 로그인 버튼
                ElevatedButton.icon(
                  onPressed: () => _googleLogin(context),
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                  label: const Text(
                    'Google 계정으로 시작하기',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 이메일 로그인 (푸른색 배경 + 흰색 텍스트)
                ElevatedButton(
                  onPressed: () => _goToLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('이메일 로그인(ID/비번찾기)'),
                ),
                const SizedBox(height: 10),

                // 이메일 가입 (푸른색 배경 + 흰색 텍스트)
                ElevatedButton(
                  onPressed: () => _goToSignup(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('이메일로 가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
