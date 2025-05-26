import 'package:flutter/material.dart';
import 'my_record.dart';
import 'favorite_record.dart';
import 'my_info_page.dart'; // ← 여기에 my_info_page.dart import 추가

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // 내 정보 항목
              GestureDetector(
                onTap: () {
                  // 👉 내 정보 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyInfoPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '내 정보',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 내 기록 항목
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyRecordPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '내 기록',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 즐겨찾기 기록 항목
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteRecordPage(favoriteRecords: []),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '즐겨찾기 기록',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
