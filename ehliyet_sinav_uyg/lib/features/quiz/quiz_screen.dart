import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/progress_bar.dart';
import 'widgets/question_page.dart';
import '../result/result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _pageController = PageController(initialPage: quizProvider.currentIndex);

    // Listen to page changes to update provider's currentIndex
    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && page != quizProvider.currentIndex) {
        quizProvider.setCurrentIndex(page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final questions = quizProvider.questions;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sınav')),
        body: const Center(child: Text('Soru bulunamadı.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav'),
        centerTitle: true,
        actions: [
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              if (!settingsProvider.timerEnabled) {
                return const SizedBox.shrink();
              }
              // This Consumer only rebuilds the timer text
              return Consumer<QuizProvider>(
                builder: (context, quizProvider, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        '${(quizProvider.timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(quizProvider.timerSeconds % 60).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // This Consumer only rebuilds the progress bar
            Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return ProgressBar(
                  currentQuestionIndex: quizProvider.currentIndex,
                  totalQuestions: questions.length,
                );
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return QuestionPage(
                    question: questions[index],
                    questionIndex: index,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // This Consumer only rebuilds the navigation buttons when index changes
            Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: quizProvider.currentIndex > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          : null,
                      child: const Text('Önceki'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (quizProvider.currentIndex < questions.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          quizProvider.finishQuiz();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ResultScreen()),
                          );
                        }
                      },
                      child: Text(quizProvider.currentIndex < questions.length - 1
                          ? 'Sonraki'
                          : 'Bitir'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}