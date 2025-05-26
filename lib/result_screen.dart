import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:camera/camera.dart';

class ResultScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ResultScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
        elevation: 1,
        centerTitle: true, // 중앙 정렬
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 흰색 아이콘
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '검사 결과',
          style: TextStyle(
            color: Colors.white, // 흰색 텍스트
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 기존 상단 '검사 결과' 푸른색 박스 삭제됨

            const SizedBox(height: 40),
            // 스트레스 점수와 해결방안
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 1.2),
              ),
              child: Column(
                children: [
                  const Text(
                    '스트레스 점수 : ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '75 (심각)',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '해결방안 추천 : \n산책, 명상, 음악(발라드)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // 여유 공간 추가
            // 인공지능(AI) 추천
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 1.2),
              ),
              child: Column(
                children: const [
                  Text(
                    '인공지능(AI) 추천 :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '음악 = 모든 날 모든 순간(폴킴)\n밤 편지(아이유)',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // 여유 공간 추가
            // 완료 버튼 (푸른색 배경 + 흰색 텍스트)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(cameras: [cameras.first]),
                    ),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6), // 푸른색
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(fontSize: 18, color: Colors.white), // 흰색 텍스트
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
