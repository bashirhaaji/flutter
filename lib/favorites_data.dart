import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesData {
  static const _favoritesKey = 'favorites';
  static const _recentsKey = 'recents';
  static late SharedPreferences _prefs;

  static List<Map<String, String>> favorites = [];
  static List<Map<String, String>> recents = [];

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    favorites = _decodeList(_prefs.getString(_favoritesKey));
    recents = _decodeList(_prefs.getString(_recentsKey));
  }

  static List<Map<String, String>> _decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .whereType<Map>()
          .map(
            (e) => e.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _persist(
    String key,
    List<Map<String, String>> value,
  ) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  static Future<void> addFavorite(Map<String, String> item) async {
    favorites.removeWhere((e) => e['word'] == item['word']);
    favorites.insert(0, item);
    await _persist(_favoritesKey, favorites);
  }

  static Future<void> removeFavoriteAt(int index) async {
    if (index < 0 || index >= favorites.length) return;
    favorites.removeAt(index);
    await _persist(_favoritesKey, favorites);
  }

  static bool isFavorite(String word) {
    return favorites.any((element) => element['word'] == word);
  }

  static Future<void> addRecent(Map<String, String> item) async {
    recents.removeWhere((e) => e['word'] == item['word']);
    recents.insert(0, {...item, 'timestamp': DateTime.now().toIso8601String()});
    if (recents.length > 30) {
      recents = recents.sublist(0, 30);
    }
    await _persist(_recentsKey, recents);
  }
}
