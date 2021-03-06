import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int score;
  final VoidCallback resetHandler;

  Result(this.score, this.resetHandler);

  String get resultPhrase {
    if (score <= 8) {
      return "You are awesome and innocent!";
    } else if (score <= 12) {
      return "Pretty likeable!";
    } else if (score <= 16) {
      return "You are... strange!";
    } else {
      return "You are so bad!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhrase,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            child: Text('Restart Quiz!'),
            onPressed: resetHandler,
          )
        ],
      ),
    );
  }
}
