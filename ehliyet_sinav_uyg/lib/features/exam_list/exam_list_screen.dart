import 'package:flutter/material.dart';
import '../../data/repositories/question_repository.dart';
import '../category/category_screen.dart';

class ExamListScreen extends StatefulWidget {
  final String month;
  const ExamListScreen({super.key, required this.month});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late final QuestionRepository _questionRepository;
  Future<List<String>>? _examsFuture;

  @override
  void initState() {
    super.initState();
    _questionRepository = QuestionRepository();
    _examsFuture = _questionRepository.getExamsForMonth(widget.month);
  }

  @override
  Widget build(BuildContext context) {
    String formatMonthName(String monthKey) {
      switch (monthKey.toLowerCase()) {
        case 'ocak': return 'Ocak';
        case 'subat': return 'Şubat';
        case 'mart': return 'Mart';
        case 'nisan': return 'Nisan';
        case 'mayis': return 'Mayıs';
        case 'haziran': return 'Haziran';
        case 'temmuz': return 'Temmuz';
        case 'agustos': return 'Ağustos';
        case 'eylul': return 'Eylül';
        case 'ekim': return 'Ekim';
        case 'kasim': return 'Kasım';
        case 'aralik': return 'Aralık';
        default:
          return monthKey.substring(0, 1).toUpperCase() + monthKey.substring(1);
      }
    }

    String formatExamId(String examId) {
      final parts = examId.split('_');
      if (parts.length != 2) return examId; // Fallback
      return '${parts[0]} ${formatMonthName(parts[1])}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${formatMonthName(widget.month)} Sınavları'),
      ),
      body: FutureBuilder<List<String>>(
        future: _examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final exams = snapshot.data;

          if (exams == null || exams.isEmpty) {
            return const Center(child: Text('Bu ay için hiç sınav bulunamadı.'));
          }

          return ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final examId = exams[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(formatExamId(examId)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: 'Deneme Sınavı',
                          categoryKey: 'deneme_sinavlari',
                          month: widget.month,
                          testId: examId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}