import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _sorularRef = FirebaseDatabase.instance.ref().child('sorular');
  final DatabaseReference _indexRef = FirebaseDatabase.instance.ref().child('exam_index');

  // --- Methods for Deneme Sınavları ---
  Future<List<String>> getMonths() async {
    try {
      final snapshot = await _indexRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map;
        const monthOrder = [
          'ocak', 'subat', 'mart', 'nisan', 'mayis', 'haziran', 
          'temmuz', 'agustos', 'eylul', 'ekim', 'kasim', 'aralik'
        ];
        final monthKeys = data.keys
            .cast<String>()
            .where((key) => monthOrder.contains(key.toLowerCase()))
            .toList();
        monthKeys.sort((a, b) {
          final indexA = monthOrder.indexOf(a.toLowerCase());
          final indexB = monthOrder.indexOf(b.toLowerCase());
          if (indexA == -1) return 1;
          if (indexB == -1) return -1;
          return indexB.compareTo(indexA);
        });
        return monthKeys;
      }
      return [];
    } catch (e) {
      // Error handling
      return [];
    }
  }

  Future<List<String>> getExamsForMonth(String month) async {
    try {
      final snapshot = await _indexRef.child(month).get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map;
        final examKeys = data.keys.cast<String>().toList();
        examKeys.sort((a, b) {
          final numA = int.tryParse(a.split('_').first) ?? 0;
          final numB = int.tryParse(b.split('_').first) ?? 0;
          return numA.compareTo(numB);
        });
        return examKeys;
      }
      return [];
    } catch (e) {
      // Error handling
      return [];
    }
  }

  // --- Generic Question Fetching Logic ---

  Future<List<String>> getTestListForCategory(String categoryKey) async {
    try {
      final snapshot = await _sorularRef.child(categoryKey).get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map;
        final testKeys = data.keys.cast<String>().toList();
        testKeys.sort((a, b) {
          final numA = int.tryParse(a.split('_').last) ?? 0;
          final numB = int.tryParse(b.split('_').last) ?? 0;
          return numA.compareTo(numB);
        });
        return testKeys;
      }
      return [];
    } catch (e) {
      // Error handling
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getQuestionsForTest({
    required String categoryKey,
    String? month,
    required String testId,
  }) async {
    try {
      DatabaseReference pathRef;
      if (categoryKey == 'deneme_sinavlari' && month != null) {
        pathRef = _sorularRef.child(categoryKey).child(month).child(testId);
      } else {
        pathRef = _sorularRef.child(categoryKey).child(testId);
      }

      final snapshot = await pathRef.get();
      if (snapshot.exists && snapshot.value != null) {
        return _parseQuestions(snapshot.value);
      }
      return [];
    } catch (e) {
      // Error handling
      return [];
    }
  }

  // --- Private Parsing Helper ---
  List<Map<String, dynamic>> _parseQuestions(Object? data) {
    final questionsData = data as Map;
    final questionsList = <Map<String, dynamic>>[];

    questionsData.forEach((key, value) {
      final questionMap = value as Map;

      if ((questionMap['soru'] == null && questionMap['resim'] == null && questionMap['resimBase64'] == null) || 
          questionMap['cevap'] == null || 
          questionMap['secenekler'] == null) {
        return;
      }

      String soru = questionMap['soru'] as String? ?? '';
      final dogru = questionMap['cevap'] as String;
      final seceneklerList = questionMap['secenekler'] as List;
      final resimBase64 = (questionMap['resimBase64'] ?? questionMap['resim']) as String?;

      if (soru.isEmpty && resimBase64 != null) {
        soru = "Şekle göre aşağıdakilerden hangisi doğrudur?";
      }

      final seceneklerMap = <String, Map<String, String?>>{};
      for (final option in seceneklerList) {
          final optionMap = option as Map;
          final harf = optionMap['harf'];
          if (harf is String) {
            final metin = optionMap['metin'] as String?;
            final resim = optionMap['resim'] as String?;
            if (metin != null || resim != null) {
              seceneklerMap[harf] = {'text': metin, 'imageBase64': resim};
            }
          }
      }
      
      if (seceneklerMap.length < 2) return;

      final aciklama = questionMap['aciklama'] as String?;

      questionsList.add({
        'id': key,
        'kategori': 'Deneme Sınavı', // This might need to be dynamic
        'soru': soru,
        'secenekler': seceneklerMap,
        'dogru': dogru,
        'aciklama': aciklama,
        'resimBase64': resimBase64,
      });
    });
    return questionsList;
  }
}
