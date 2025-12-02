import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/question.dart';
import '../../../providers/quiz_provider.dart';
import 'option_tile.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  final int questionIndex;

  const QuestionPage({
    super.key,
    required this.question,
    required this.questionIndex,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build
    final options = widget.question.secenekler.entries.toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.soru,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (widget.question.resimBase64 != null && widget.question.resimBase64!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.memory(
                base64Decode(widget.question.resimBase64!),
                gaplessPlayback: true, // Helps prevent flickering on rebuild
              ),
            ),
          const SizedBox(height: 24),
          // Use a Consumer here to only rebuild the options when an option is selected
          Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              return Column(
                children: options.map((entry) {
                  final optionKey = entry.key;
                  final option = entry.value;
                  final isSelected = quizProvider.isOptionSelected(widget.questionIndex, optionKey);
                  final isCorrect = widget.question.dogru == optionKey;

                  return OptionTile(
                    optionKey: optionKey,
                    option: option,
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    showResult: quizProvider.isFinished,
                    onTap: () {
                      if (!quizProvider.isFinished) {
                        quizProvider.selectOption(widget.questionIndex, optionKey);
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
