import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';

class ApiService {
  static const String _baseUrl = 'https://www.freetogame.com/api';

  // Mengambil daftar semua game untuk Home Page.
  Future<List<Game>> fetchGames() async {
    final url = Uri.parse('$_baseUrl/games');
    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar game (${response.statusCode})');
    }

    // Responsnya berupa list JSON: [ {...}, {...} ]
    final body = jsonDecode(response.body) as List<dynamic>;

    return body
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Mengambil detail satu game untuk Detail Page.
  Future<Game> fetchGameDetail(int id) async {
    final url = Uri.parse('$_baseUrl/game?id=$id');
    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail game (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    // Jika id tidak ditemukan, API mengirim {"status": 0, ...}.
    if (body['status'] == 0) {
      throw Exception('Data game tidak ditemukan');
    }

    return Game.fromJson(body);
  }
}
