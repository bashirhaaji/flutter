import 'package:flutter/material.dart';

import '../favorites_data.dart';
import '../services/api_service.dart';
import '../word_models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  final ApiService api = ApiService();

  WordDefinition? result;
  bool isLoading = false;
  String? error;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
      error = null;
      result = null;
    });

    try {
      final res = await api.fetchDefinition(controller.text);
      setState(() {
        result = res;
        isLoading = false;
      });

      final primaryDefinition = _primaryDefinition(res);
      await FavoritesData.addRecent({
        'word': res.word,
        'definition': primaryDefinition.definition,
        'example': primaryDefinition.example,
        'phonetic': res.phonetic,
        'partOfSpeech': res.meanings.isNotEmpty
            ? res.meanings.first.partOfSpeech
            : '',
      });
    } catch (e) {
      setState(() {
        error = e is ApiException ? e.message : 'Something went wrong.';
        isLoading = false;
      });
    }
  }

  DefinitionItem _primaryDefinition(WordDefinition res) {
    if (res.meanings.isNotEmpty && res.meanings.first.definitions.isNotEmpty) {
      return res.meanings.first.definitions.first;
    }
    return DefinitionItem(definition: 'No definition available.', example: '');
  }

  bool get _hasSearched => isLoading || result != null || error != null;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF5682B1);
    const lightBlue = Color(0xFF739EC9);
    const cream = Color(0xFFFFE8DB);
    const black = Color(0xFF000000);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Word'), backgroundColor: blue),
      body: Container(
        decoration: _hasSearched
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [cream, lightBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : const BoxDecoration(color: cream),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter a word...',
                  prefixIcon: const Icon(Icons.search, color: blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => _search(),
              ),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: isLoading ? null : _search,
                style: FilledButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Search'),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (error != null) {
                      return Center(
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (result != null) {
                      final word = result!;
                      final primary = _primaryDefinition(word);
                      return Card(
                        color: Colors.white,
                        shadowColor: blue.withOpacity(0.2),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.menu_book, color: blue, size: 30),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          word.word,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: black,
                                          ),
                                        ),
                                        if (word.phonetic.isNotEmpty)
                                          Text(
                                            word.phonetic,
                                            style: TextStyle(
                                              color: black.withOpacity(0.6),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: word.meanings.length,
                                  itemBuilder: (context, index) {
                                    final meaning = word.meanings[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (meaning.partOfSpeech.isNotEmpty)
                                            Text(
                                              meaning.partOfSpeech,
                                              style: TextStyle(
                                                color: blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ...meaning.definitions.map(
                                            (d) => Padding(
                                              padding: const EdgeInsets.only(
                                                top: 6,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    d.definition,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: black.withOpacity(
                                                        0.8,
                                                      ),
                                                    ),
                                                  ),
                                                  if (d.example.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 4,
                                                          ),
                                                      child: Text(
                                                        '"${d.example}"',
                                                        style: TextStyle(
                                                          color: black
                                                              .withOpacity(0.7),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    await FavoritesData.addFavorite({
                                      'word': word.word,
                                      'definition': primary.definition,
                                      'example': primary.example,
                                      'phonetic': word.phonetic,
                                    });
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to Favorites!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: lightBlue,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: Icon(
                                    FavoritesData.isFavorite(word.word)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  label: Text(
                                    FavoritesData.isFavorite(word.word)
                                        ? 'In Favorites'
                                        : 'Add to Favorites',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Center(
                      child: Text(
                        'Search for any word to see its meaning here.',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
