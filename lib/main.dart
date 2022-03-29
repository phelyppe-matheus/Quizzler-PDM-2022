import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quizzler/quiz_brain.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBrain quizes = QuizBrain();
  List<Icon> score = [];
  Icon rightAnswer = const Icon(Icons.check, color: Colors.green);
  Icon wrongAnswer = const Icon(Icons.delete, color: Colors.red);
  Icon nonAnswered = const Icon(Icons.warning, color: Colors.yellow);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 244, 248),
      appBar: AppBar(
        title: const Text('Quizzler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(quizes.getQuestionText()),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: answerButton(Colors.green, 'True', onPressed: () {
                    if (quizes.getQuestionAnswer() == true) {
                      score.add(rightAnswer);
                    } else {
                      score.add(wrongAnswer);
                    }
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: answerButton(Colors.yellow, 'Maybe', onPressed: () {
                    score.add(nonAnswered);
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: answerButton(Colors.red, 'False', onPressed: () {
                    if (quizes.getQuestionAnswer() == false) {
                      score.add(rightAnswer);
                    } else {
                      score.add(wrongAnswer);
                    }
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: score.length,
                  itemBuilder: (BuildContext context, int index) =>
                      score[index],
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton answerButton(Color bgColor, String text,
      {required Function onPressed}) {
    return TextButton(
      onPressed: () {
        setState(() {
          onPressed();
        });
        quizes.nextQuestion();
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      style: TextButton.styleFrom(backgroundColor: bgColor),
    );
  }
}
