import 'package:flutter/material.dart';
import '../../data/repositories/question_repository.dart';
import '../category/category_screen.dart';

class TestListScreen extends StatefulWidget {
  final String categoryKey;
  final String displayName;

  const TestListScreen({
    super.key, 
    required this.categoryKey,
    required this.displayName,
  });

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  late final QuestionRepository _questionRepository;
  Future<List<String>>? _testsFuture;

  @override
  void initState() {
    super.initState();
    _questionRepository = QuestionRepository();
    _testsFuture = _questionRepository.getTestListForCategory(widget.categoryKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),
      ),
      body: FutureBuilder<List<String>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final tests = snapshot.data;

          if (tests == null || tests.isEmpty) {
            return const Center(child: Text('Bu kategori için hiç test bulunamadı.'));
          }

          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final testId = tests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(testId.replaceAll('_', ' ')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: widget.displayName,
                          categoryKey: widget.categoryKey,
                          testId: testId,
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
