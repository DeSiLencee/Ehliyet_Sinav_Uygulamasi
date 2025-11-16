import 'package:flutter/material.dart';
import 'dart:async';
import '../data/models/question.dart';
import '../data/repositories/question_repository.dart';

class QuizProvider with ChangeNotifier {
  final QuestionRepository _questionRepository;
  List<Question> _questions = [];
  int _currentIndex = 0;
  Map<int, String> _selectedOptions = {}; // Question index to selected option (A, B, C, D)
  int _correctCount = 0;
  bool _isFinished = false;
  Set<int> _flaggedQuestions = {}; // Stores indices of flagged questions
  int _timerSeconds = 45 * 60; // 45 minutes in seconds
  Timer? _timer;
  String? _categoryKey;

  QuizProvider({QuestionRepository? questionRepository})
      : _questionRepository = questionRepository ?? QuestionRepository();

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Map<int, String> get selectedOptions => _selectedOptions;
  int get correctCount => _correctCount;
  bool get isFinished => _isFinished;
  Set<int> get flaggedQuestions => _flaggedQuestions;
  int get timerSeconds => _timerSeconds;
  String? get categoryKey => _categoryKey;

  Future<void> loadQuestions({
    required String categoryKey,
    String? month,
    required String testId,
  }) async {
    _categoryKey = categoryKey;
    _questions = await _questionRepository.getQuestions(
      categoryKey: categoryKey,
      month: month,
      testId: testId,
    );
    _questions.shuffle(); // Shuffle the questions for a random order

    _currentIndex = 0;
    _selectedOptions = {};
    _correctCount = 0;
    _isFinished = false;
    _flaggedQuestions = {};
    notifyListeners();
  }

  void selectOption(int questionIndex, String option) {
    if (!_isFinished) {
      _selectedOptions[questionIndex] = option;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void finishQuiz() {
    _isFinished = true;
    _correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedOptions.containsKey(i) &&
          _selectedOptions[i] == _questions[i].dogru) {
        _correctCount++;
      }
    }
    notifyListeners();
  }

  void toggleFlag(int questionIndex) {
    if (_flaggedQuestions.contains(questionIndex)) {
      _flaggedQuestions.remove(questionIndex);
    }
    else {
      _flaggedQuestions.add(questionIndex);
    }
    notifyListeners();
  }

  bool isOptionSelected(int questionIndex, String option) {
    return _selectedOptions[questionIndex] == option;
  }

  String? getSelectedOption(int questionIndex) {
    return _selectedOptions[questionIndex];
  }

  bool isCorrect(int questionIndex) {
    return _selectedOptions[questionIndex] == _questions[questionIndex].dogru;
  }

  bool isFlagged(int questionIndex) {
    return _flaggedQuestions.contains(questionIndex);
  }

  int get incorrectCount {
    if (!_isFinished) return 0;
    int count = 0;
    _selectedOptions.forEach((index, selectedOption) {
      if (selectedOption != _questions[index].dogru) {
        count++;
      }
    });
    return count;
  }

  int get emptyCount {
    if (!_isFinished) return 0;
    return _questions.length - _selectedOptions.length;
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        finishQuiz(); // Automatically finish quiz when timer runs out
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}