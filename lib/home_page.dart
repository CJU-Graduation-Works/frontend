import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'my_page.dart';

class HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomePage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // 밝은 배경
      appBar: AppBar(
        title: const Text(
          '홈',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF3B82F6), // 진한 블루
        elevation: 2,
        // actions 배열 삭제해서 버튼 없음
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            '스트레스 분석 카메라',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B82F6), // 파란색
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(cameras: cameras),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3B82F6), // 버튼 텍스트 색상
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blue.shade100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt, size: 100, color: Color(0xFF3B82F6)),
                    SizedBox(height: 12),
                    Text(
                      '검사하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
            activeIcon: Icon(Icons.home, color: Color(0xFF3B82F6)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
            activeIcon: Icon(Icons.person, color: Color(0xFF3B82F6)),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // 홈 버튼 클릭시, 홈 화면으로 돌아가기
            Navigator.pop(context);
          } else if (index == 1) {
            // 마이페이지 버튼 클릭시, 마이페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
