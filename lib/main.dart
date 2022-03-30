import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';

void main() async => runApp(const Quizzler());

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
  List<Icon> scoreIcons = [];
  int scoreRight = 0;
  int scoreWrong = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 244, 248),
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
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(quizes.getQuestionText()),
                    ),
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
                      rightAnswer();
                    } else {
                      wrongAnswer();
                    }
                  }, context: context),
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
                    nonAnswered();
                  }, context: context),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: answerButton(
                      const Color.fromRGBO(244, 67, 54, 1), 'False',
                      onPressed: () {
                    if (quizes.getQuestionAnswer() == false) {
                      rightAnswer();
                    } else {
                      wrongAnswer();
                    }
                  }, context: context),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: scoreIcons.length,
                  itemBuilder: (BuildContext context, int index) =>
                      scoreIcons[index],
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
      {required Function onPressed, required BuildContext context}) {
    return TextButton(
      onPressed: () {
        setState(() {
          onPressed();
        });

        String percentage =
            ((scoreRight / (scoreRight + scoreWrong)) * 100).toStringAsFixed(0);

        SnackBar snackBar = SnackBar(
          content: Text('You answered $percentage% right.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

  void rightAnswer() {
    scoreIcons.add(const Icon(Icons.check, color: Colors.green));
    scoreRight++;
  }

  void wrongAnswer() {
    scoreIcons.add(const Icon(Icons.delete, color: Colors.red));
    scoreWrong++;
  }

  void nonAnswered() {
    scoreIcons.add(const Icon(Icons.warning, color: Colors.yellow));
  }
}
