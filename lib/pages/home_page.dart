import 'package:flutter/material.dart';
import 'main_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF5682B1);
    const lightBlue = Color(0xFF739EC9);
    const cream = Color(0xFFFFE8DB);
    const black = Color(0xFF000000);

    return Scaffold(
      appBar: AppBar(title: const Text('Word Dictionary')),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [cream, lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 100, color: blue),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Word Dictionary',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Explore words, meanings, and more — all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigation(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Start Searching'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
