import 'package:flutter/material.dart';

import '../database/hive_service.dart';
import '../models/game.dart';
import '../widgets/game_card.dart';
import 'detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final HiveService _hiveService = HiveService();

  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _games = _hiveService.getAll();
  }

  // Membaca ulang data dari Hive lalu menggambar ulang layar.
  void _reload() {
    setState(() {
      _games = _hiveService.getAll();
    });
  }

  Future<void> _confirmDelete(Game game) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus game?'),
          content: Text('${game.name} akan dihapus dari library.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await _hiveService.remove(game.id);
    if (!mounted) return;

    _reload();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${game.name} dihapus dari library')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library Anda',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Empty state
    if (_games.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.video_library_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Library masih kosong.\nDapatkan game dari halaman Beranda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _games.length,
      itemBuilder: (context, index) {
        final game = _games[index];
        return GameCard(
          game: game,
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(game),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(gameId: game.id),
              ),
            );
            // Setelah kembali dari Detail, muat ulang data library.
            if (!mounted) return;
            _reload();
          },
        );
      },
    );
  }
}
