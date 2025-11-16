import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';


import '../quiz/widgets/option_tile.dart'; // Reusing option tile

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yanıtları Gözden Geçir'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quizProvider.questions.length,
        itemBuilder: (context, index) {
          final question = quizProvider.questions[index];
          final selectedOption = quizProvider.getSelectedOption(index);
          

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Soru ${index + 1}: ${question.soru}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...question.secenekler.entries.map((entry) {
                    final optionKey = entry.key;
                    final option = entry.value; // entry.value is an Option object
                    final isOptionSelected = selectedOption == optionKey;
                    final isOptionCorrect = question.dogru == optionKey;

                    return OptionTile(
                      optionKey: optionKey,
                      option: option, // Pass the Option object
                      isSelected: isOptionSelected,
                      isCorrect: isOptionCorrect,
                      showResult: true, // Always show result in review
                      onTap: () {}, // Not interactive in review
                    );
                  }),
                  if (question.aciklama != null && question.aciklama!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Açıklama: ${question.aciklama}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}