import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  QuizBrain quizes = QuizBrain();

  List<Icon> scoreIcons = [];
  int scoreRight = 0;
  int scoreWrong = 0;

  @override
  void initState() {
    super.initState();

    _prefs.then((prefs) {
      int counter = 0;
      while (counter < 10) {
        int? value = prefs.getInt('answer$counter');
        if (value == 0) {
          print('false');
          wrongAnswer(counter);
        } else if (value == 1) {
          print('true');
          rightAnswer(counter);
        } else if (value == 2) {
          print('maybe');
          nonAnswered(counter);
        } else {
          print('end');
          break;
        }
        setState(() {});
        counter++;
      }
      quizes.questionNumber = prefs.getInt('lastQuestion') ?? 0;
    });
  }

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
                      rightAnswer(quizes.getIndex);
                    } else {
                      wrongAnswer(quizes.getIndex);
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
                    nonAnswered(quizes.getIndex);
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
                      rightAnswer(quizes.getIndex);
                    } else {
                      wrongAnswer(quizes.getIndex);
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

        _prefs.then((prefs) {
          prefs.setInt('lastQuestion', quizes.getIndex);
        });
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

  void rightAnswer(index) {
    scoreIcons.add(const Icon(Icons.check, color: Colors.green));
    scoreRight++;
    _prefs.then((prefs) {
      prefs.setInt('answer$index', 1);
    });
  }

  void wrongAnswer(index) {
    scoreIcons.add(const Icon(Icons.delete, color: Colors.red));
    scoreWrong++;
    _prefs.then((prefs) {
      prefs.setInt('answer$index', 0);
    });
  }

  void nonAnswered(index) {
    scoreIcons.add(const Icon(Icons.warning, color: Colors.yellow));
    _prefs.then((prefs) {
      prefs.setInt('answer$index', 2);
    });
  }
}
