import 'package:flutter/material.dart';

import '../favorites_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF5682B1);
    const lightBlue = Color(0xFF739EC9);
    const cream = Color(0xFFFFE8DB);
    const black = Color(0xFF000000);

    final hasFavorites = FavoritesData.favorites.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), backgroundColor: blue),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [cream, lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: hasFavorites
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: FavoritesData.favorites.length,
                itemBuilder: (context, index) {
                  final item = FavoritesData.favorites[index];

                  return Card(
                    color: Colors.white,
                    shadowColor: blue.withOpacity(0.2),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: blue.withOpacity(0.9),
                        child: Text(
                          item['word']![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item['word']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                      subtitle: Text(
                        item['definition']!,
                        style: TextStyle(color: black.withOpacity(0.7)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Remove Favorite"),
                                content: Text(
                                  "Are you sure you want to remove '${item['word']}' from favorites?",
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      FavoritesData.removeFavoriteAt(
                                        index,
                                      ).then((_) {
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_outline, color: blue, size: 80),
                    const SizedBox(height: 20),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your saved words will appear here.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
