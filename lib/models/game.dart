import 'package:hive/hive.dart';

// File ini dibuat otomatis oleh build_runner.
part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String genre;

  @HiveField(4)
  final String platform;

  @HiveField(5)
  final String releaseDate;

  @HiveField(6)
  final String publisher;

  @HiveField(7)
  final String developer;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final List<String> screenshots;

  Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.platform,
    required this.releaseDate,
    required this.publisher,
    required this.developer,
    required this.description,
    required this.screenshots,
  });

  // Membuat Game dari JSON FreeToGame.
  // Dipakai untuk item daftar (/games) maupun detail (/game?id=).
  factory Game.fromJson(Map<String, dynamic> json) {
    // Hanya respons detail yang punya "screenshots":
    // [{"id": 1, "image": "https://..."}]
    final screenshotList = (json['screenshots'] as List<dynamic>? ?? [])
        .map((s) => s['image'].toString())
        .toList();

    return Game(
      id: json['id'] as int,
      name: json['title']?.toString() ?? 'Tanpa Nama',
      imageUrl: json['thumbnail']?.toString() ?? '',
      genre: json['genre']?.toString() ?? 'Unknown',
      platform: json['platform']?.toString() ?? 'Unknown',
      releaseDate: json['release_date']?.toString() ?? '-',
      publisher: json['publisher']?.toString() ?? '-',
      developer: json['developer']?.toString() ?? '-',
      // Detail punya "description", daftar hanya punya "short_description".
      description:
          json['description']?.toString() ??
          json['short_description']?.toString() ??
          '',
      screenshots: screenshotList,
    );
  }
}
