import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
// import 'package:path/path.dart';
// import 'package:quizzler/score_loader.dart';
// import 'package:sqflite/sqflite.dart';

void main() async {
  runApp(const Quizzler());
}

// Future<void> loadDatabase() async {

//   WidgetsFlutterBinding.ensureInitialized();
//   final database = openDatabase(
//     join(await getDatabasesPath(), 'question_database.db'),
//     onCreate: (db, version) {
//       return db.execute(
//           'CREATE TABLE answers(id INTEGER PRIMARY KEY, answer BOOLEAN)');
//     },
//     version: 0,
//   );

//   Future<void> insertLoadedScore(Answers answers) async {
//     final db = await database;

//     await db.insert(
//       'answers',
//       answers.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
// }

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

  Icon rightAnswer = const Icon(Icons.check, color: Colors.green);
  Icon wrongAnswer = const Icon(Icons.delete, color: Colors.red);
  Icon nonAnswered = const Icon(Icons.warning, color: Colors.yellow);

  // @override
  // void initState() async {
  //   await loadDatabase();
  // }

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
              flex: 0,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '$scoreRight',
                  textAlign: TextAlign.end,
                ),
              ),
            ),
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
                      scoreIcons.add(rightAnswer);
                      scoreRight++;
                    } else {
                      scoreIcons.add(wrongAnswer);
                      scoreWrong++;
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
                    scoreIcons.add(nonAnswered);
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
                      scoreIcons.add(rightAnswer);
                      scoreRight++;
                    } else {
                      scoreIcons.add(wrongAnswer);
                      scoreWrong++;
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
}
