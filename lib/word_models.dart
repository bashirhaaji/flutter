class WordDefinition {
  final String word;
  final String phonetic;
  final List<Meaning> meanings;

  WordDefinition({
    required this.word,
    required this.phonetic,
    required this.meanings,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return WordDefinition(
      word: (json['word'] ?? '').toString(),
      phonetic: (json['phonetic'] ?? '').toString(),
      meanings: (json['meanings'] as List<dynamic>? ?? [])
          .map((m) => Meaning.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'word': word,
    'phonetic': phonetic,
    'meanings': meanings.map((m) => m.toJson()).toList(),
  };
}

class Meaning {
  final String partOfSpeech;
  final List<DefinitionItem> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: (json['partOfSpeech'] ?? '').toString(),
      definitions: (json['definitions'] as List<dynamic>? ?? [])
          .map((d) => DefinitionItem.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'partOfSpeech': partOfSpeech,
    'definitions': definitions.map((d) => d.toJson()).toList(),
  };
}

class DefinitionItem {
  final String definition;
  final String example;

  DefinitionItem({required this.definition, required this.example});

  factory DefinitionItem.fromJson(Map<String, dynamic> json) {
    return DefinitionItem(
      definition: (json['definition'] ?? '').toString(),
      example: (json['example'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'definition': definition,
    'example': example,
  };
}
