import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hydra_games/database/hive_service.dart';
import 'package:hydra_games/models/game.dart';

Game buatGame(int id, String nama) {
  return Game(
    id: id,
    name: nama,
    imageUrl: 'https://example.com/$id.jpg',
    genre: 'Action',
    platform: 'Windows',
    releaseDate: '1 Jan, 2026',
    publisher: 'Pub',
    developer: 'Dev',
    description: 'Deskripsi',
    screenshots: ['a.jpg', 'b.jpg'],
  );
}

void main() {
  late Directory tempDir;
  final service = HiveService();

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(GameAdapter());
    await Hive.openBox<Game>(HiveService.boxName);
  });

  setUp(() async {
    await service.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('add menyimpan game dan isOwned bernilai true', () async {
    expect(service.isOwned(1), false);

    await service.add(buatGame(1, 'Game Satu'));

    expect(service.isOwned(1), true);
    expect(service.count(), 1);
  });

  test('getAll mengembalikan objek Game lengkap', () async {
    await service.add(buatGame(2, 'Game Dua'));

    final hasil = service.getAll();

    expect(hasil.length, 1);
    expect(hasil.first.name, 'Game Dua');
    expect(hasil.first.screenshots.length, 2);
  });

  test('remove menghapus game', () async {
    await service.add(buatGame(3, 'Game Tiga'));

    await service.remove(3);

    expect(service.isOwned(3), false);
    expect(service.count(), 0);
  });
}
