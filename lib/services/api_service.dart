import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../word_models.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.code});
  final String message;
  final int? code;

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _androidBase = 'http://10.0.2.2:3000';
  static const _localBase = 'http://localhost:3000';

  String get _baseUrl {
    if (kIsWeb) return _localBase;
    if (defaultTargetPlatform == TargetPlatform.android) return _androidBase;
    return _localBase;
  }

  Future<WordDefinition> fetchDefinition(String word) async {
    final trimmed = word.trim();
    if (trimmed.isEmpty) {
      throw ApiException('Please enter a word to search.');
    }

    final uri = Uri.parse(
      '$_baseUrl/api/define',
    ).replace(queryParameters: {'word': trimmed});

    final resp = await _client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      return WordDefinition.fromJson(jsonBody);
    }

    if (resp.statusCode == 404) {
      throw ApiException('No definition found for "$trimmed".', code: 404);
    }

    throw ApiException(
      'Something went wrong. Please try again later.',
      code: resp.statusCode,
    );
  }
}
