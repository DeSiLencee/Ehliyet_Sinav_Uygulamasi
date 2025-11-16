import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../review/review_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final categoryKey = quizProvider.categoryKey;

    final correctAnswers = quizProvider.correctCount;
    final incorrectAnswers = quizProvider.incorrectCount;
    final emptyAnswers = quizProvider.emptyCount;

    final score = correctAnswers * 2;
    final bool passed = score >= 70;
    final String resultMessage = passed ? 'Tebrikler, Sınavı Geçtiniz!' : 'Maalesef, Sınavı Geçemediniz';
    final Color resultColor = passed ? Colors.green : Colors.red;

    final bool showResults = categoryKey == 'deneme_sinavlari';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuçlar'),
        centerTitle: true,
        automaticallyImplyLeading: false, // No back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (showResults) ...[
                      Text(
                        resultMessage,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: resultColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Puanınız: $score',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                    ],
                    _buildResultRow('Doğru Sayısı:', '$correctAnswers', Colors.green),
                    _buildResultRow('Yanlış Sayısı:', '$incorrectAnswers', Colors.red),
                    _buildResultRow('Boş Sayısı:', '$emptyAnswers', Colors.grey),
                  ],
                ),
              ),
            ),
            const Spacer(), // Pushes buttons to the bottom
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen()),
                );
              },
              icon: const Icon(Icons.remove_red_eye),
              label: const Text('Yanıtları Gözden Geçir'),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // Go back to home screen
              },
              icon: const Icon(Icons.home), // Changed Icon
              label: const Text('Anasayfaya Dön'), // Changed Text
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, color: color),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}