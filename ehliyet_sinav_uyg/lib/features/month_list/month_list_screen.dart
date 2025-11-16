import 'package:flutter/material.dart';
import '../../data/repositories/question_repository.dart';
import '../exam_list/exam_list_screen.dart';

class MonthListScreen extends StatefulWidget {
  const MonthListScreen({super.key});

  @override
  State<MonthListScreen> createState() => _MonthListScreenState();
}

class _MonthListScreenState extends State<MonthListScreen> {
  late final QuestionRepository _questionRepository;
  Future<List<String>>? _monthsFuture;

  @override
  void initState() {
    super.initState();
    _questionRepository = QuestionRepository();
    _monthsFuture = _questionRepository.getMonths();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Ayını Seçin'),
      ),
      body: FutureBuilder<List<String>>(
        future: _monthsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final months = snapshot.data;

          if (months == null || months.isEmpty) {
            return const Center(child: Text('Hiç sınav ayı bulunamadı.'));
          }

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(formatMonthName(month)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamListScreen(month: month),
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
