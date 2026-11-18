import 'package:flutter/material.dart';

import '../models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  // Widget di sisi kanan kartu. Kalau null, dipakai ikon panah.
  final Widget? trailing;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 120,
              height: 70,
              child: Image.network(
                webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                game.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Nama, genre, platform
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        game.genre,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.platform,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
