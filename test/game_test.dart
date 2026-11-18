import 'package:flutter_test/flutter_test.dart';
import 'package:hydra_games/models/game.dart';

void main() {
  test('Game.fromJson membaca item daftar FreeToGame', () {
    final json = {
      'id': 540,
      'title': 'Overwatch 2',
      'thumbnail': 'https://example.com/t.jpg',
      'short_description': 'Game tembak tim.',
      'genre': 'Shooter',
      'platform': 'PC (Windows)',
      'publisher': 'Activision Blizzard',
      'developer': 'Blizzard Entertainment',
      'release_date': '2022-10-04',
    };

    final game = Game.fromJson(json);

    expect(game.id, 540);
    expect(game.name, 'Overwatch 2');
    expect(game.genre, 'Shooter');
    expect(game.platform, 'PC (Windows)');
    expect(game.description, 'Game tembak tim.');
    expect(game.screenshots, isEmpty);
  });

  test('Game.fromJson membaca detail beserta screenshots', () {
    final json = {
      'id': 540,
      'title': 'Overwatch 2',
      'thumbnail': 'https://example.com/t.jpg',
      'description': 'Deskripsi lengkap.',
      'short_description': 'Singkat.',
      'genre': 'Shooter',
      'platform': 'PC (Windows)',
      'release_date': '2022-10-04',
      'screenshots': [
        {'id': 1, 'image': 'https://example.com/1.jpg'},
        {'id': 2, 'image': 'https://example.com/2.jpg'},
      ],
    };

    final game = Game.fromJson(json);

    expect(game.description, 'Deskripsi lengkap.');
    expect(game.screenshots.length, 2);
    expect(game.screenshots.first, 'https://example.com/1.jpg');
  });

  test('Game.fromJson aman jika field kosong', () {
    final game = Game.fromJson({'id': 1});

    expect(game.name, 'Tanpa Nama');
    expect(game.genre, 'Unknown');
    expect(game.screenshots, isEmpty);
  });
}
