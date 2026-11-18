import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra_games/models/game.dart';
import 'package:hydra_games/widgets/game_card.dart';

void main() {
  testWidgets('GameCard menampilkan nama, genre, dan platform', (tester) async {
    final game = Game(
      id: 1,
      name: 'Game Contoh',
      imageUrl: '',
      genre: 'Action',
      platform: 'Windows',
      releaseDate: '-',
      publisher: '-',
      developer: '-',
      description: '',
      screenshots: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameCard(game: game, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Game Contoh'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Windows'), findsOneWidget);
  });
}
