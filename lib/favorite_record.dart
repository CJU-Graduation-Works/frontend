import 'package:flutter/material.dart';

class FavoriteRecordPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecords;

  const FavoriteRecordPage({super.key, required this.favoriteRecords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6), // 배경 푸른색
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // 뒤로가기 버튼 흰색
        title: const Text(
          '즐겨찾기 기록',
          style: TextStyle(color: Colors.white), // 텍스트 흰색
        ),
      ),
      body: favoriteRecords.isEmpty
          ? const Center(child: Text('즐겨찾기된 기록이 없습니다.'))
          : ListView.builder(
        itemCount: favoriteRecords.length,
        itemBuilder: (context, index) {
          final record = favoriteRecords[index];
          return ListTile(
            title: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '스트레스 점수 : ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '${record["score"]}(${record["level"]})',
                    style: TextStyle(color: _getLevelColor(record["level"])),
                  ),
                  TextSpan(
                    text: ' / ${record["date"]}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Color _getLevelColor(String level) {
    switch (level) {
      case "심각":
        return Colors.red;
      case "보통":
        return Colors.orange;
      case "무난":
        return const Color(0xFF3B82F6); // 푸른색 적용
      case "준수":
        return Colors.lightBlue;
      default:
        return Colors.black;
    }
  }
}
