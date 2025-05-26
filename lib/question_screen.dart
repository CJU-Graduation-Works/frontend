import 'dart:math';
import 'package:flutter/material.dart';
import 'questions.dart';
import 'result_screen.dart';
import 'package:camera/camera.dart';

class QuestionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const QuestionScreen({super.key, required this.cameras});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<String> selectedQuestions = [];
  Map<int, String> answers = {};

  @override
  void initState() {
    super.initState();
    selectedQuestions = List.from(allQuestions)..shuffle(Random());
    selectedQuestions = selectedQuestions.take(5).toList();
  }

  void _updateAnswer(int index, String value) {
    setState(() {
      answers[index] = value;
    });
  }

  int calculateScore() {
    int totalScore = 0;
    answers.forEach((index, answer) {
      if (answer == '예') totalScore += 20;
    });
    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    bool isAllAnswered = answers.length == selectedQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6), // 푸른색 배경
        elevation: 1,
        title: const Text(
          '스트레스 진단',
          style: TextStyle(color: Colors.white), // 흰색 텍스트
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 흰색 아이콘
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [
              ...selectedQuestions.asMap().entries.map((entry) {
                int index = entry.key;
                String question = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. $question',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: answers[index] == '예',
                                onChanged: (_) => _updateAnswer(index, '예'),
                                activeColor: Colors.blue,
                              ),
                              const Text('예'),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: answers[index] == '아니오',
                                onChanged: (_) => _updateAnswer(index, '아니오'),
                                activeColor: Colors.blue,
                              ),
                              const Text('아니오'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAllAnswered
                      ? () {
                    int totalScore = calculateScore();
                    debugPrint("총점: $totalScore");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(cameras: widget.cameras),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAllAnswered ? Colors.blue : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    '제출하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
