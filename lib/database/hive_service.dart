import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';

class HiveService {
  static const String boxName = 'library';

  // Dipanggil sekali di main() sebelum runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameAdapter());
    await Hive.openBox<Game>(boxName);
  }

  // Box sudah dibuka di init(), jadi di sini cukup diambil.
  Box<Game> get _box => Hive.box<Game>(boxName);

  // READ: semua game di library.
  List<Game> getAll() {
    return _box.values.toList();
  }

  // READ: apakah game dengan id ini sudah dimiliki?
  bool isOwned(int id) {
    return _box.containsKey(id);
  }

  // READ: jumlah game di library (untuk Profile Page).
  int count() {
    return _box.length;
  }

  // CREATE: tambah game, id game dipakai sebagai key.
  Future<void> add(Game game) async {
    await _box.put(game.id, game);
  }

  // DELETE: hapus game berdasarkan id.
  Future<void> remove(int id) async {
    await _box.delete(id);
  }

  // DELETE: kosongkan library (dipakai bila diperlukan).
  Future<void> clear() async {
    await _box.clear();
  }
}
