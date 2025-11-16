class Option {
  final String? text;
  final String? imageBase64;

  Option({this.text, this.imageBase64});

  // Helper to check what kind of content this option has
  bool get isText => text != null;
  bool get isImage => imageBase64 != null;
}

class Question {
  final String id;
  final String kategori;
  final String soru;
  final Map<String, Option> secenekler;
  final String dogru;
  final String? aciklama;
  final String? resimBase64; // Image for the question itself

  Question({
    required this.id,
    required this.kategori,
    required this.soru,
    required this.secenekler,
    required this.dogru,
    this.aciklama,
    this.resimBase64,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      kategori: json['kategori'] as String,
      soru: json['soru'] as String,
      secenekler: (json['secenekler'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          Option(
            text: value['text'],
            imageBase64: value['imageBase64'],
          ),
        ),
      ),
      dogru: json['dogru'] as String,
      aciklama: json['aciklama'] as String?,
      resimBase64: json['resimBase64'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': kategori,
      'soru': soru,
      'secenekler': secenekler.map((key, value) => MapEntry(key, {
        'text': value.text,
        'imageBase64': value.imageBase64,
      })),
      'dogru': dogru,
      'aciklama': aciklama,
      'resimBase64': resimBase64,
    };
  }
}