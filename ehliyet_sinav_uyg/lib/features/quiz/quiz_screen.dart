import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/option_tile.dart';
import 'widgets/progress_bar.dart';
import '../result/result_screen.dart'; // Will create this next

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuizProvider, SettingsProvider>(
      builder: (context, quizProvider, settingsProvider, child) {
        if (quizProvider.questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sınav')),
            body: const Center(child: Text('Soru bulunamadı.')),
          );
        }

        final currentQuestion = quizProvider.questions[quizProvider.currentIndex];
        final options = currentQuestion.secenekler.entries.toList();

        // TODO: Implement shuffling options based on settingsProvider.shuffleOptions

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sınav'),
            centerTitle: true,
            actions: [
              if (settingsProvider.timerEnabled)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      '${(quizProvider.timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(quizProvider.timerSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProgressBar(
                  currentQuestionIndex: quizProvider.currentIndex,
                  totalQuestions: quizProvider.questions.length,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.soru,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (currentQuestion.resimBase64 != null && currentQuestion.resimBase64!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Image.memory(
                              key: ValueKey(currentQuestion.id),
                              base64Decode(currentQuestion.resimBase64!),
                            ),
                          ),
                        const SizedBox(height: 24),
                        ...options.map((entry) {
                          final optionKey = entry.key;
                          final option = entry.value; // entry.value is now an Option object
                          final isSelected = quizProvider.isOptionSelected(
                              quizProvider.currentIndex, optionKey);
                          final isCorrect = currentQuestion.dogru == optionKey;

                          return OptionTile(
                            optionKey: optionKey,
                            option: option, // Pass the Option object
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            showResult: quizProvider.isFinished,
                            onTap: () {
                              if (!quizProvider.isFinished) {
                                quizProvider.selectOption(
                                    quizProvider.currentIndex, optionKey);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: quizProvider.currentIndex > 0
                          ? () => quizProvider.previousQuestion()
                          : null,
                      child: const Text('Önceki'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (quizProvider.currentIndex < quizProvider.questions.length - 1) {
                          quizProvider.nextQuestion();
                        } else {
                          quizProvider.finishQuiz();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ResultScreen()),
                          );
                        }
                      },
                      child: Text(quizProvider.currentIndex < quizProvider.questions.length - 1
                          ? 'Sonraki'
                          : 'Bitir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}