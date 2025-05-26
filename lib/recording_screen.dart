import 'package:flutter/material.dart';
import 'question_screen.dart';
import 'package:camera/camera.dart';

class RecordingScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RecordingScreen({super.key, required this.cameras});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isRecording = false;

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionScreen(cameras: widget.cameras),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
        elevation: 1,
        title: const Text(
          '음성 녹음',
          style: TextStyle(color: Colors.white), // 흰색 텍스트
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 흰색 아이콘
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '아래의 문장을\n또박또박 읽어주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent, width: 1.2),
                ),
                child: const Text(
                  '“네가 어떤 모습이든 그대로도 충분히 아름다워.”',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleRecording,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red : Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.redAccent : Colors.blueAccent).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isRecording ? '녹음 중...' : '눌러서 녹음 시작',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
