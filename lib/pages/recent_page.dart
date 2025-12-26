import 'package:flutter/material.dart';

import '../favorites_data.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  int? expandedIndex;

  String _friendlyTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      return '${diff.inDays} d ago';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF5682B1);
    const lightBlue = Color(0xFF739EC9);
    const cream = Color(0xFFFFE8DB);
    const black = Color(0xFF000000);

    final recentWords = FavoritesData.recents;
    final hasRecent = recentWords.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Recent Searches')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [cream, lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: hasRecent
            ? ListView.builder(
                itemCount: recentWords.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = recentWords[index];
                  final isExpanded = expandedIndex == index;

                  return Card(
                    color: Colors.white,
                    shadowColor: blue.withOpacity(0.2),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: lightBlue,
                            child: Text(
                              item['word']?.substring(0, 1).toUpperCase() ??
                                  '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            item['word'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                          subtitle: Text(
                            _friendlyTime(item['timestamp'] ?? ''),
                            style: TextStyle(color: black.withOpacity(0.6)),
                          ),
                          trailing: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: blue,
                          ),
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Text(
                                  item['definition'] ?? '',
                                  style: TextStyle(
                                    color: black.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Example:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: black.withOpacity(0.9),
                                  ),
                                ),
                                Text(
                                  '"${item['example'] ?? ''}"',
                                  style: TextStyle(
                                    color: black.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondChild: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: blue, size: 80),
                    const SizedBox(height: 20),
                    const Text(
                      'No recent searches',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your recently searched words will appear here.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
