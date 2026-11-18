// ignore_for_file: avoid_print
import 'package:hydra_games/services/api_service.dart';

Future<void> main() async {
  final api = ApiService();

  try {
    final games = await api.fetchGames();
    print('Berhasil: ${games.length} game');

    for (final g in games.take(10)) {
      print('${g.id} | ${g.name} | ${g.genre} | ${g.platform}');
    }

    final detail = await api.fetchGameDetail(games.first.id);
    print('\nDetail: ${detail.name}');
    print('Rilis     : ${detail.releaseDate}');
    print('Developer : ${detail.developer}');
    print('Publisher : ${detail.publisher}');
    print('Screenshot: ${detail.screenshots.length}');
  } catch (e) {
    print('ERROR: $e');
  }
}
