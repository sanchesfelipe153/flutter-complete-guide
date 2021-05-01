import 'package:flutter/material.dart';
import 'package:quiz_app/answer.dart';
import 'package:quiz_app/question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function(int score) answerQuestion;

  Quiz({
    required this.questions,
    required this.questionIndex,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questionIndex]['questionText'] as String,
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) => Answer(
                  answer['text'] as String,
                  () => answerQuestion(answer['score'] as int),
                ))
      ],
    );
  }
}
