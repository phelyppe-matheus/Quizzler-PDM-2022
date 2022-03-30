import 'question.dart';

class QuizBrain {
  int _questionNumber;

  final List<Question> _questionBank;

  QuizBrain()
      : _questionNumber = 0,
        _questionBank = [
          Question('Sal refinado é branco?', true),
          Question('Barata voa?', true),
          Question('Kakaroto morre?', true),
          Question('Angiosperma tem fruto?', true),
          Question('A soma de dois numeros aleatórios aumenta a aleatoriedade?',
              false),
          Question('E o pão, morreu?', true),
          Question('A magda é inteligente?', false),
          Question('O sol é ciano?', false),
          Question('O Will Smith nunca bateu no Chris Rock?', false),
          Question('A barata tem sete saias de filó?', false),
          Question('O Phelyppe é a pessoa mais bonita que cê já viu na vida?',
              false),
        ];

  String getQuestionText() {
    return _questionBank[_questionNumber].text;
  }

  bool getQuestionAnswer() {
    return _questionBank[_questionNumber].answer;
  }

  void reset() {
    _questionNumber = 0;
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber += 1;
    } else {
      reset();
    }
  }

  get getIndex {
    return _questionNumber;
  }

  set questionNumber(number) {
    _questionNumber = number;
  }
}
