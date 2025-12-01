import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../quiz/quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String category;      // The display name (e.g., "İlk Yardım")
  final String categoryKey;   // The firebase key (e.g., "ilk_yardim")
  final String? month;        // Optional: for deneme sinavlari
  final String testId;        // The selected test/exam id

  const CategoryScreen({
    super.key, 
    required this.category,
    required this.categoryKey,
    this.month,
    required this.testId,
  });

  String _formatMonthName(String monthKey) {
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

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    String appBarTitle;
    if (month != null && testId.contains('_')) {
      final parts = testId.split('_');
      if (parts.length >= 2) {
        final day = parts[0];
        final monthKey = parts[1];
        appBarTitle = '$day ${_formatMonthName(monthKey)}';
      } else {
        appBarTitle = testId.replaceAll('_', ' ');
      }
    } else {
      appBarTitle = testId.replaceAll('_', ' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Ayarları',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Soruları Karıştır'),
                        Switch(
                          value: settingsProvider.shuffleQuestions,
                          onChanged: (value) {
                            settingsProvider.setShuffleQuestions(value);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Zamanlayıcı'),
                        Switch(
                          value: settingsProvider.timerEnabled,
                          onChanged: (value) {
                            settingsProvider.setTimerEnabled(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await quizProvider.loadQuestions(
                  categoryKey: categoryKey,
                  month: month,
                  testId: testId,
                );

                if (!context.mounted) return;

                if (settingsProvider.timerEnabled) {
                  quizProvider.startTimer();
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                ).then((_) {
                  if (settingsProvider.timerEnabled) {
                    quizProvider.stopTimer();
                  }
                });
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Testi Başlat'),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}