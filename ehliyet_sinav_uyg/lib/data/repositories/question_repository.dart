import 'package:ehliyet_sinav_uyg/services/firebase_service.dart';
import '../models/question.dart';

class QuestionRepository {
  final FirebaseService _firebaseService;

  QuestionRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  // --- Methods for Deneme Sınavları ---
  Future<List<String>> getMonths() async {
    return await _firebaseService.getMonths();
  }

  Future<List<String>> getExamsForMonth(String month) async {
    return await _firebaseService.getExamsForMonth(month);
  }

  // --- Methods for other categories ---
  Future<List<String>> getTestListForCategory(String categoryKey) async {
    return await _firebaseService.getTestListForCategory(categoryKey);
  }

  // --- Generic method to get questions ---
  Future<List<Question>> getQuestions({
    required String categoryKey,
    String? month,
    required String testId,
  }) async {
    final questionsData = await _firebaseService.getQuestionsForTest(
      categoryKey: categoryKey,
      month: month,
      testId: testId,
    );
    // The service now returns a parsed list of maps, ready for fromJson
    return questionsData.map((json) => Question.fromJson(json)).toList();
  }
}
