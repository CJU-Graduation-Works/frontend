import 'package:flutter/material.dart';
import 'my_page.dart';

class MyRecordPage extends StatefulWidget {
  const MyRecordPage({super.key});

  @override
  _MyRecordPageState createState() => _MyRecordPageState();
}

class _MyRecordPageState extends State<MyRecordPage> {
  final List<Map<String, dynamic>> records = const [
    {"score": 75, "level": "심각", "date": "25.03.25"},
    {"score": 55, "level": "보통", "date": "25.03.25"},
    {"score": 40, "level": "무난", "date": "25.03.25"},
    {"score": 15, "level": "준수", "date": "25.03.25"},
  ];

  List<bool> favorites = [false, false, false, false];

  Color _getLevelColor(String level) {
    switch (level) {
      case "심각":
        return Colors.red;
      case "보통":
        return Colors.orange;
      case "무난":
        return const Color(0xFF3B82F6); // 지정 색상 적용 (푸른색)
      case "준수":
        return Colors.lightBlue;
      default:
        return Colors.black;
    }
  }

  void _showRecordDetail(BuildContext context, Map<String, dynamic> record, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 별 + 점수
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        favorites[index] ? Icons.star : Icons.star_border,
                        color: favorites[index] ? Colors.yellow : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          favorites[index] = !favorites[index];
                        });
                        Navigator.of(context).pop(); // 닫고 다시 열기
                        _showRecordDetail(context, record, index);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '스트레스 점수: ${record["score"]}',
                      style: TextStyle(fontSize: 24, color: _getLevelColor(record["level"])),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  '해결방안 추천: 산책, 명상, 음악(발라드)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),
                const Text(
                  '이용자를 위한 추천:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),
                const Text(
                  '음악 = 모든날 모든순간(폴킴)\n밤 편지(아이유)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6), // 파란색 배경
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 흰색 아이콘
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          '내 기록',
          style: TextStyle(
            color: Colors.white, // 흰색 텍스트
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
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
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: record["date"],
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showRecordDetail(context, record, index);
            },
          );
        },
      ),
    );
  }
}
