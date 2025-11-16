import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../data/models/question.dart';

class OptionTile extends StatelessWidget {
  final String optionKey;
  final Option option;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.optionKey,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? tileColor;
    Color? textColor;
    IconData? icon;

    if (showResult) {
      if (isSelected) {
        if (isCorrect) {
          tileColor = Theme.of(context).colorScheme.secondary; // Correct answer
          icon = Icons.check_circle;
        } else {
          tileColor = Theme.of(context).colorScheme.error; // Wrong answer
          icon = Icons.cancel;
        }
      } else if (isCorrect) {
        tileColor = Theme.of(context).colorScheme.secondary.withAlpha(128); // Correct but not selected
        icon = Icons.check_circle_outline;
      }
      textColor = Colors.white; // Text color for result display
    } else {
      tileColor = isSelected ? Theme.of(context).primaryColor.withAlpha(51) : null;
      textColor = Theme.of(context).textTheme.bodyLarge?.color;
    }

    Widget optionContent;
    if (option.isImage && option.imageBase64 != null) {
      optionContent = Container(
        height: 120,
        alignment: Alignment.centerLeft,
        child: Image.memory(
          base64Decode(option.imageBase64!),
          fit: BoxFit.contain,
        ),
      );
    } else {
      optionContent = Text(
        option.text ?? '',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: tileColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: showResult ? Colors.white.withAlpha(77) : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  optionKey,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: showResult ? Colors.white : Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: optionContent, // Use the new widget here
              ),
              if (showResult && icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
