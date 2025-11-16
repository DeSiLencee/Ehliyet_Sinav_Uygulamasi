import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../data/models/question.dart';

class LocalJsonLoader {
  Future<List<Question>> load(String categoryAssetPath) async {
    try {
      final String response = await rootBundle.loadString(categoryAssetPath);
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      // Handle error, e.g., file not found or JSON parsing error
      
      return []; // Return an empty list on error
    }
  }
}